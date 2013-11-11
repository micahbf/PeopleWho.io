BT.Views.UserShowView = Backbone.View.extend({
  template: JST['users/show'],

  initialize: function () {
    this.listenTo(this.model, "sync", this.render);
  },

  events: {
    "click .settle-btn": "settle"
  },

  render: function () {
    var renderedContent = this.template({
      user: this.model
    });

    this.$el.html(renderedContent);
    return this;
  },

  settle: function (event) {
    event.preventDefault();
    var user = BT.users.get($(event.target).data("user-id"));
    user.settle();
    this.render();
  }
});