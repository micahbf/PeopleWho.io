BT.Views.RootView = Backbone.View.extend({
  render: function () {
    var $layout = $(JST['layouts/main']());
    debugger;

    var balancesView = new BT.Views.UserBalanceView();
    var newBillFormView = new BT.Views.NewBillFormView();

    $layout.find("#main").append(balancesView.render().$el);
    $layout.find("#form").append(newBillFormView.render().$el);
    this.$el = $layout;
    return this;
  }
});