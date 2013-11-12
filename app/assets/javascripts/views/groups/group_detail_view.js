BT.Views.GroupDetailView = Backbone.View.extend({
  template: JST['groups/detail'],

  render: function () {
    var users = _.map(this.model.get("user_ids"), function (user_id) {
      return BT.users.get(user_id);
    });

    var userDisplayNames = _.map(users, function(user) {
      return user.displayName();
    });

    renderedContent = this.template({
      group: this.model,
      displayNames: userDisplayNames,
      users: users,
      bills: this.model.bills
    });

    this.$el.html(renderedContent);
    return this;
  }
});