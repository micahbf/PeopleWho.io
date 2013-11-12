window.BT = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    var bootstrap_users = JSON.parse($('#users_index_bootstrap').html());
    var bootstrap_groups = JSON.parse($('#groups_bootstrap').html());

    BT.users = new BT.Collections.Users(bootstrap_users.users);
    BT.balances = bootstrap_users.balances;
    BT.bills = new BT.Collections.Bills();
    BT.groups = bootstrap_groups;

    new BT.Routers.AppRouter($('#content'));
    Backbone.history.start();
  },

  recalculateBalances: function(newBill) {
    var updatedUserIds = [];
    newBill.billSplits.each(function(split) {
      var debtorId = split.get("debtor_id");
      updatedUserIds.push(debtorId);

      if (BT.balances[debtorId] === undefined) {
        BT.balances[debtorId] = split.get("amount");
      } else {
        BT.balances[debtorId] += split.get("amount");
      }
    });

    BT.bills.trigger("newBalances", updatedUserIds);
  },

  populateUserAutocompletes: function () {
    BT.userAutocompletes = [];
    BT.users.each(function (user) {
      BT.userAutocompletes.push(user.escape("email"));
      if (user.get("name")) {
        BT.userAutocompletes.push(user.escape("name"));
      }
    });

    _.each(BT.groups, function(group) {
      BT.userAutocompletes.push(group.name);
    });
  },

  int_to_dec: function (int) {
    return (int/100).toFixed(2);
  },

  dec_to_int: function (dec) {
    return Math.floor(parseFloat(dec) * 100);
  }
};

$(document).ready(function(){
  if (typeof NO_BACKBONE === 'undefined' || !NO_BACKBONE) {
    BT.initialize();
  }
});
