BT.Views.RootView = Backbone.View.extend({
  render: function () {
    var balancesView = new BT.Views.UserBalanceView();
    this.$el.html(balancesView.render().$el);
    return this;
  }
});