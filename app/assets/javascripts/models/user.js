BT.Models.User = Backbone.Model.extend({
  displayName: function () {
    if (this.name) {
      return this.name;
    } else {
      return this.email;
    }
  }
});