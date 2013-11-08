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
    var self = this;
    var user = BT.users.get(id);
    var userView;
    user.fetch({
      success: function () {
        userView = new BT.Views.UserShowView({
          model: user
        });

        self._swapMain(userView);
      }
    });
  },

  _swapLayout: function(newView) {
    if (this._currView) {
      this._currView.remove();
    }

    this.$rootEl.html(newView.render().$el);
    this._currView = newView;
  },

  _swapMain: function(newView) {
    $main = this.$rootEl.find('#main');
    $main.html(newView.render().$el);
  }
});