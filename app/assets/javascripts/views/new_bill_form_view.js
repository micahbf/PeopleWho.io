BT.Views.NewBillFormView = Backbone.View.extend({
  template: JST['bills/form'],
  splitTemplate: JST['bills/form_bill_split'],
  splitCounter: 0,

  events: {
    "click #add-split": "addSplit",
    "submit": "submit"
  },

  initialize: function () {
    if(BT.userAutocompletes === undefined) {
      BT.populateUserAutocompletes();
    }
  },

  render: function () {
    var $renderedForm = $(this.template());
    this.$splitsDiv = $renderedForm.find("#bill-splits");
    this.addSplit();
    this.$el.append($renderedForm);
    return this;
  },

  addSplit: function () {
    var $renderedSplit = $(this.splitTemplate({
      splitNum: this.splitCounter
    }));

    $renderedSplit.find(".user-autocomplete").typeahead({
      name: 'users',
      local: BT.userAutocompletes
    });

    this.$splitsDiv.append($renderedSplit);
    this.splitCounter += 1;
  },

  submit: function (event) {
    event.preventDefault();
    var billAttrs = $(event.target).serializeJSON();

    _.each(billAttrs.bill.bill_splits_attributes, function (splitAttrs) {
      var user = BT.users.find(function (user) {
        return (user.get("email") === splitAttrs.debtor_ident ||
                user.get("name") === splitAttrs.debtor_ident);
      });
      splitAttrs.debtor_id = user.id;
      delete splitAttrs.debtor_ident;
    });

    var bill = new BT.Models.Bill();
    BT.bills.create(billAttrs);
  }
});