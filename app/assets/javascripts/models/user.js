BT.Models.User = Backbone.Model.extend({
  displayName: function () {
    if (this.name) {
      return this.escape("name");
    } else {
      return this.escape("email");
    }
  }
});