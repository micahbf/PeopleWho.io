BT.Views.NewBillFormView = Backbone.View.extend({
  template: JST['bills/form'],
  splitTemplate: JST['bills/form_bill_split'],
  splitCounter: 0,

  events: {
    "click #add-split": "addSplit",
    "click #currency-select-btn": "dropCurrencySearch",
    "blur #currency-search-field": "updateCurrency",
    "focus .bill-root": "slideDownSplits",
    "blur .bill-root": "maybeSlideUpSplits",
    "submit form": "submit"
  },

  initialize: function () {
    if(BT.userAutocompletes === undefined) {
      BT.populateUserAutocompletes();
    }
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
    this.addSplit();
    this.$splitsDiv.hide();

    this.$el.append($renderedForm);
    this.$el.addClass("panel panel-default");
    return this;
  },

  addSplit: function () {
    var $renderedSplit = $(this.splitTemplate({
      splitNum: this.splitCounter
    }));

    $renderedSplit.find(".user-autocomplete").autocomplete({
      source: BT.userAutocompletes
    });

    this.$splitsTable.find("#bill-form-buttons").before($renderedSplit);
    this.splitCounter += 1;
  },

  dropCurrencySearch: function (event) {
    $("#currency-dropdown-ul").show();
    $("#currency-search-field").focus();
  },

  updateCurrency: function (event) {
    var newCurrencyCode = $("#currency-search-field").val();
    $("#currency-dropdown-ul").hide();
    $(".currency-selection").html(newCurrencyCode);
  },

  slideDownSplits: function (event) {
    this.$splitsDiv.slideDown(200);
  },

  maybeSlideUpSplits: function (event) {
    if (_.all($('.bill-root'), function (el) { return $(el).val() === ""; })) {
      this.$splitsDiv.slideUp(200);
    }
  },

  submit: function (event) {
    event.preventDefault();
    var self = this;
    var billAttrs = $(event.target).serializeJSON();
    var syncUsers = false;
    var isGroupSplit = false;

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

    var bill = new BT.Models.Bill();
    bill.save(billAttrs, {
      success: function () {
        if (syncUsers) {
          event.target.reset();
          self.$splitsDiv.slideUp(200);

          BT.users.fetch({
            reset: true,
            async: false
          });
        }

        BT.bills.add(bill);
        BT.recalculateBalances(bill);
      }
    });
  }
});