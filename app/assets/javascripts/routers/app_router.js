BT.Routers.AppRouter = Backbone.Router.extend({
  initialize: function ($rootEl) {
    this.$rootEl = $rootEl;
  },

  routes: {
    "": "showRoot"
  },

  showRoot: function () {
    var rootView = new BT.Views.RootView();

    this._swapView(rootView);
  },

  _swapView: function(newView) {
    if (this._currView) {
      this._currView.remove();
    }

    this.$rootEl.html(newView.render().$el);
    this._currView = newView;
  }
});