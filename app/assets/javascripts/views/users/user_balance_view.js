BT.Views.UserBalanceView = Backbone.View.extend({
  template: JST['users/balances'],

  initialize: function () {
    this.listenTo(BT.bills, "newBalances", this.render);
  },

  render: function () {
    var owedUsers = {};
    var owingUsers = {};

    _.each(BT.balances, function (balance, user_id) {
      var dispName = BT.users.get(user_id).displayName();
      if (balance < 0) {
        owedUsers[dispName] = BT.int_to_dec(balance);
      } else {
        owingUsers[dispName] = BT.int_to_dec(balance);
      }
    });

    var renderedBalances = this.template({
      owedUsers: owedUsers,
      owingUsers: owingUsers
    });

    this.$el.html(renderedBalances);
    return this;
  }
});