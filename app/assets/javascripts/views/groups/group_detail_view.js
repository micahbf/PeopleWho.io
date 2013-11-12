BT.Views.GroupDetailView = Backbone.View.extend({
  template: JST['groups/detail'],

  render: function () {
    users = _.map(this.model.user_ids, function (user_id) {
      return BT.users.get(user_id);
    });

    renderedContent = this.template({
      group: this.model,
      users: users,
      bills: this.model.bills
    });

    this.$el.html(renderedContent);
    return this;
  }
});