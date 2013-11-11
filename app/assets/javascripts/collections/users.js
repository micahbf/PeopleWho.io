BT.Collections.Users = Backbone.Collection.extend({
  url: "/api/users",
  model: BT.Models.User,
  parse: function (serverAttrs) {
    return serverAttrs.users;
  }
});