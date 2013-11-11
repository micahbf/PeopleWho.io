BT.Routers.AppRouter = Backbone.Router.extend({
  initialize: function ($rootEl) {
    this.$rootEl = $rootEl;
    this._initLayout();
  },

  routes: {
    "": "showBalances",
    "users/:id": "showUser"
  },

  showBalances: function (id) {
    var balancesView = new BT.Views.UserBalanceView();

    this._swapMain(balancesView);
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

  _initLayout: function() {
    var rootView = new BT.Views.RootView();
    this.$rootEl.html(rootView.render().$el);

    var groupsPanelView = new BT.Views.GroupsPanelView();
    $groupsPanel = this.$rootEl.find('#groups-panel');
    $groupsPanel.html(groupsPanelView.render().$el);
  },

  _swapMain: function(newView) {
    if (this._currMain) {
      _currMain.remove();
    }
    $main = this.$rootEl.find('#main');
    $main.html(newView.render().$el);
    _currMain = newView;
  }
});