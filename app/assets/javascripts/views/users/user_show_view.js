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
    var userId = $(event.target).data("user-id");
    $.ajax({
      url: "/api/users/" + userId + "/settle",
      type: "post",
      success: function () {
        $("tr[data-user-id='" + userId + "']").fadeOut();
      }
    });
  }
});