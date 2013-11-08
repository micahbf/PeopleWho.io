BT.Routers.AppRouter = Backbone.Router.extend({
  initialize: function ($rootEl) {
    this.$rootEl = $rootEl;
  },

  routes: {
    "": "showRoot",
    "users/:id": "showUser"
  },

  showRoot: function () {
    var rootView = new BT.Views.RootView();

    this._swapLayout(rootView);
  },

  showUser: function (id) {
    var user = BT.users.get(id);
    user.fetch();

    var userView = new BT.Views.UserShowView({
      model: user
    });

    this._swapMain(userView);
  },

  _swapLayout: function(newView) {
    if (this._currView) {
      this._currView.remove();
    }

    this.$rootEl.replaceWith(newView.render().$el);
    this._currView = newView;
  },

  _swapMain: function(newView) {
    $main = this.$rootEl.find('#main');
    $main.html(newView.render().$el);
  }
});