BT.Views.RootView = Backbone.View.extend({
  userBalancesTemplate: JST['users/balances'],

  render: function () {
    var owed_users = {};
    var owing_users = {};

    _.each(BT.balances, function (balance, user_id) {
      var disp_name = BT.Collections.Users.get(user_id).display_name();
      if (balance < 0) {
        owed_users[disp_name] = balance;
      } else {
        owing_users[disp_name] = balance;
      }
    });

    var renderedBalances = this.userBalancesTemplate({
      owed_users: owed_users,
      owing_users: owing_users
    });

    this.$el.html(renderedBalances);
    return this;
  }
});