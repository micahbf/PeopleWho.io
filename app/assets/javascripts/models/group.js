BT.Models.Group = Backbone.Model.extend({
  urlRoot: "/api/groups",
  collection: BT.Collections.Groups,
  parse: function (serverAttrs) {
    if (serverAttrs.group.bills) {
      this.bills = new BT.Collections.Bills(serverAttrs.group.bills);
      delete serverAttrs.group.bills;
    }

    return serverAttrs;
  }
});