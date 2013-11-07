BT.Views.RootView = Backbone.View.extend({
  render: function () {
    var balancesView = new BT.Views.UserBalanceView();
    this.$el.html(balancesView.render().$el);
    var newBillFormView = new BT.Views.NewBillFormView();
    this.$el.prepend(newBillFormView.render().$el);
    return this;
  }
});