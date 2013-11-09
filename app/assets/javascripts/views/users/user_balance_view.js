BT.Views.UserBalanceView = Backbone.View.extend({
  template: JST['users/balances'],

  initialize: function () {
    this.listenTo(BT.bills, "newBalances", this.render);
  },

  events: {
    "click .settle-btn": "settle"
  },

  render: function (updatedUserIds) {
    var owedUsers = [];
    var owingUsers = [];

    _.each(BT.balances, function (balance, user_id) {
      var user = BT.users.get(user_id);
      if (balance < 0) {
        owedUsers.push({
          user: user,
          balance: BT.int_to_dec(balance)
        });
      } else {
        owingUsers.push({
          user: user,
          balance: BT.int_to_dec(balance)
        });
      }
    });

    var renderedBalances = this.template({
      owedUsers: owedUsers,
      owingUsers: owingUsers
    });

    this.$el.html(renderedBalances);
    this._animateUpdatedRows(this.$el, updatedUserIds);
    return this;
  },

  settle: function (event) {
    event.preventDefault();
    var userId = $(event.target).data("user-id");
    $.ajax({
      url: "/api/users/" + userId + "/settle",
      type: "post",
      success: function () {
        $("tr[data-user-id='" + userId + "']").fadeOut();
      }
    });
  },

  _animateUpdatedRows: function ($el, updatedUserIds) {
    _.each(updatedUserIds, function (userId) {
      $userTr = $("tr[data-user-id='" + userId + "']");
      $userTr.css({backgroundColor: "yellow"});
      $userTr.animate({backgroundColor: "white"}, 500);
    });
  }
});