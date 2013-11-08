BT.Views.RootView = Backbone.View.extend({
  render: function () {
    var $layout = $(JST['layouts/main']());
    
    var newBillFormView = new BT.Views.NewBillFormView();

    $layout.find("#form").append(newBillFormView.render().$el);
    this.$el = $layout;
    return this;
  }
});