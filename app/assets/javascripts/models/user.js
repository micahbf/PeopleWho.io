BT.Models.User = Backbone.Model.extend({
  collection: BT.Collections.Users,
  
  displayName: function () {
    if (this.get("name")) {
      return this.escape("name");
    } else {
      return this.escape("email");
    }
  },

  parse: function(serverAttrs) {
    return serverAttrs.user;
  }
});