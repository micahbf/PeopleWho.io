BT.Collections.Bills = Backbone.Collection.extend({
  url: "/api/bills",
  model: BT.Models.Bill
});