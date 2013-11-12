BT.Models.Group = Backbone.Model.extend({
  urlRoot: "/api/groups",
  collection: BT.Collections.Groups,
  parse: function (serverAttrs) {
    if (serverAttrs.bills) {
      this.bills = new BT.Collections.Bills(serverAttrs.bills);
      delete serverAttrs.bills;
    }

    return serverAttrs;
  }
});