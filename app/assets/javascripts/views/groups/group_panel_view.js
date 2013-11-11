BT.Views.GroupsPanelView = Backbone.View.extend({
  template: JST['groups/panel'],

  render: function () {
    renderedContent = this.template({
      groups: BT.groups
    });

    this.$el.html(renderedContent);
    this.$el.addClass("panel panel-default");

    return this;
  }
});