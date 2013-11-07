window.BT = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    var bootstrap_data = JSON.parse($('#users_index_bootstrap').html());
    BT.users = bootstrap_data.users;
    BT.balances = bootstrap_data.balances;
    new BT.Routers.AppRouter($('#content'));
    Backbone.history.start();
  }
};

$(document).ready(function(){
  BT.initialize();
});
