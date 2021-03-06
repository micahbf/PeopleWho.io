BT.Views.NewBillFormView = Backbone.View.extend({
  template: JST['bills/form'],
  splitTemplate: JST['bills/form_bill_split'],
  splitCounter: 0,

  events: {
    "click #add-split": "addSplit",
    "click #currency-select-btn": "dropCurrencySearch",
    "blur #currency-search-field": "updateCurrency",
    "autocompleteselect #currency-search-field": "selectCurrency",
    "focus .bill-root": "slideDownSplits",
    "blur .bill-root": "maybeSlideUpSplits",
    "blur .currency-input": "formatCurrencyInput",
    "blur #bill_total": "newBillTotal",
    "blur .split-amount-input": "maybeMarkAsNotDefault",
    "blur #bill_split_0_debtor_id": "checkIfGroup",
    "submit form": "submit"
  },

  initialize: function () {
    if(BT.userAutocompletes === undefined) {
      BT.populateUserAutocompletes();
    }

    this.currency = _.findWhere(BT.currencies, { code: "USD" });
    this.intTotal = 0;
    this.defaultSplitAmount = 0;
    this.hiddenForGroup = [];
    this.listenTo(Backbone.history, "route", this._changeContext);
  },

  render: function () {
    var $renderedForm = $(this.template());
    this.$currencySelectButton = $renderedForm.find("#currency-select-btn");
    this.$currencySearchField = $renderedForm.find('#currency-search-field');
    this.$currencySearchField.autocomplete({
      source: BT.currencyAutocompletes
    });

    this.$splitsDiv = $renderedForm.find("#bs-div");
    this.$splitsTable = $renderedForm.find("#bill-splits");
    this.addSplit(false);
    this.$splitsDiv.hide();

    this.$el.html($renderedForm);
    this.$el.addClass("panel panel-default");
    return this;
  },

  addSplit: function (focus) {
    if (typeof(focus) === 'undefined') { focus = true; }

    var $renderedSplit = $(this.splitTemplate({
      splitNum: this.splitCounter,
      currencyCode: this.currency.code
    }));

    $idnField = $renderedSplit.find(".user-autocomplete");
    $idnField.autocomplete({
      source: BT.userAutocompletes
    });


    this.$splitsTable.find("#bill-form-buttons").before($renderedSplit);
    $idnField.focus();
    this.splitCounter += 1;
    this.updateSplitDefaultAmount();
  },

  dropCurrencySearch: function (event) {
    $("#currency-dropdown-ul").show();
    $("#currency-search-field").focus();
  },

  updateCurrency: function (event) {
    var newCurrencyCode = $("#currency-search-field").val();
    $("#currency-dropdown-ul").hide();

    var newCurrency = _.findWhere(BT.currencies, {code: newCurrencyCode});
    if (newCurrency !== undefined) {
      this.currency = newCurrency;
      $(".currency-selection").html(this.currency.code);
    }
  },

  selectCurrency: function (event, ui) {
    var $field = $("#currency-search-field");
    $field.val(ui.item.value);
    $field.blur();
    $("#currency-dropdown-ul").hide();
  },

  slideDownSplits: function (event) {
    this.$splitsDiv.slideDown(200);
  },

  maybeSlideUpSplits: function (event) {
    if (_.all($('.bill-root'), function (el) { return $(el).val() === ""; })) {
      this.$splitsDiv.slideUp(200);
    }
  },

  formatCurrencyInput: function (event) {
    var input = $(event.target).val();
    var stripped = input.replace(/[^0-9\.]/, "");
    if (stripped === "") { stripped = "0"; }
    var formatted = BT.int_to_dec(BT.dec_to_int(stripped));
    $(event.target).val(formatted);
  },

  newBillTotal: function(event) {
    this.intTotal = BT.dec_to_int($(event.target).val());
    this.updateSplitDefaultAmount();
  },

  updateSplitDefaultAmount: function () {
    this.defaultSplitAmount = Math.floor(this.intTotal / (this.splitCounter + 1));
    this.updateSplitDefaults();    
  },

  updateSplitDefaults: function () {
    var view = this;
    var splitInputs = this.$el.find(".split-amount-input");

    splitInputs.each(function () {
      var $input = $(this);
      if ($input.data('is-default') === true) {
        $input.val(BT.int_to_dec(view.defaultSplitAmount));
      }
    });
  },

  maybeMarkAsNotDefault: function (event) {
    $input = $(event.target);
    if ($input.val() !== BT.int_to_dec(this.defaultSplitAmount)) {
      $input.data("is-default", false);
    }
  },

  checkIfGroup: function (event) {
    var name = $(event.target).val();
    if (this._isGroup(name)) {
      this.groupifyForm();
    } else {
      this.ungroupifyForm();
    }
  },

  groupifyForm: function () {
    this.hiddenForGroup.push(this.$el.find("#add-split"));
    this.hiddenForGroup.push(this.$el.find(".split-amount-input-group"));
    _.each(this.hiddenForGroup, function ($toHide) {
      $toHide.fadeOut(200);
    });
    this.$el.find("#bill-submit-btn").focus();
  },

  ungroupifyForm: function () {
    _.each(this.hiddenForGroup, function ($toShow) {
      $toShow.fadeIn(200);
    });
  },

  submit: function (event) {
    event.preventDefault();
    var self = this;
    var billAttrs = $(event.target).serializeJSON();
    var syncUsers = false;
    var isGroupSplit = false;

    this.$splitsDiv.slideUp(200);

    _.each(billAttrs.bill.bill_splits_attributes, function (splitAttrs) {
      var group;
      var user = BT.users.find(function (user) {
        return (user.get("email") === splitAttrs.debtor_ident ||
                user.get("name") === splitAttrs.debtor_ident);
      });

      if (user === undefined) {
        group = BT.groups.findWhere({ name: splitAttrs.debtor_ident });
      }

      if (user !== undefined) {
        splitAttrs.debtor_id = user.id;
      } else if (group !== undefined) {
        billAttrs.bill.group_id = group.id;
        isGroupSplit = true;
      } else {        
        user = new BT.Models.User({email: splitAttrs.debtor_ident});
        splitAttrs.debtor_email = splitAttrs.debtor_ident;
        syncUsers = true;
      }

      delete splitAttrs.debtor_ident;
    });

    if (isGroupSplit) { delete billAttrs.bill.bill_splits_attributes; }

    if (billAttrs.bill.orig_currency_code === "") {
      billAttrs.bill.orig_currency_code = "USD";
    }

    var bill = new BT.Models.Bill();
    bill.save(billAttrs, {
      success: function () {
        self.render();

        var $panelHeading = self.$el.find(".panel-heading").eq(0);

        $panelHeading.animate({
          "background-color": "#3fb618",
          "color": "#ffffff"
        }, 200);

        $panelHeading.text("Bill saved!");

        window.setTimeout(function () {
          $panelHeading.animate({
            "background-color": "#f5f5f5",
            "color": "#333333"
          }, 200);

          $panelHeading.text("Split a bill!");
        }, 3000);

        if (syncUsers) {
          BT.users.fetch({
            reset: true,
            async: false
          });
        }

        BT.bills.add(bill);
        BT.recalculateBalances(bill);
      }
    });
  },

  _isGroup: function (name) {
    if (BT.groups.findWhere({name: name}) !== undefined) {
      return true;
    } else {
      return false;
    }
  },

  _changeContext: function (router, route, params) {
    if (route === "showGroup") {
      var groupName = BT.groups.get(params[0]).escape("name");
      this.$el.find("#bill_split_0_debtor_id").val(groupName);
      this.groupifyForm();
    } else if (route === "showUser") {
      this.ungroupifyForm();
      var displayName = BT.users.get(params[0]).displayName();
      this.$el.find("#bill_split_0_debtor_id").val(displayName);
    } else {
      this.ungroupifyForm();
      this.$el.find("#bill_split_0_debtor_id").val("");
    }
  }
});