BT.Models.Bill = Backbone.Model.extend({
  urlRoot: "/api/bills",
  
  initialize: function () {
    this.billSplits = this.billSplits || new BT.Collections.BillSplits([], {
      bill: this
    });
  },

  parse: function (serverAttrs) {
    if (serverAttrs.bill.bill_splits) {
      this.billSplits.add(serverAttrs.bill.bill_splits);

      delete serverAttrs.bill.billSplits;
    }

    return serverAttrs;
  },

  toJSON: function () {
    var json = _.extend({}, this.attributes);
    json.bill_splits = this.billSplits.toJSON;

    return json;
  }
});