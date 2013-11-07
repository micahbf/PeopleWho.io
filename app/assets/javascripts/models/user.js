BT.Models.User = Backbone.Model.extend({
  displayName: function () {
    if (this.get("name")) {
      return this.escape("name");
    } else {
      return this.escape("email");
    }
  }
});