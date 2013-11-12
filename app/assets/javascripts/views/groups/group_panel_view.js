BT.Views.GroupsPanelView = Backbone.View.extend({
  template: JST['groups/panel'],

  events: {
    "click #new-group-btn": "addNewGroupForm",
    "blur #new-group-name": "createNewGroup"
  },

  render: function () {
    renderedContent = this.template({
      groups: BT.groups
    });

    this.$el.html(renderedContent);
    this.$el.addClass("panel panel-default");

    return this;
  },

  addNewGroupForm: function(event) {
    var $newGroupLi, $nameInput;
    event.preventDefault();

    $newGroupLi = $("<li class='list-group-item new-group'></li>");
    $nameInput = $("<input type='text' id='new-group-name' class='form-control'>");
    $newGroupLi.append($nameInput);

    this.$el.find(".list-group").append($newGroupLi);
    $nameInput.focus();
  },

  createNewGroup: function(event) {
    var newGroupName = $(event.target).val();
    if (newGroupName !== "") {
      var newGroup = BT.groups.create({ name: newGroupName });
      this.render();
    } else {
      this.$el.find(".new-group").remove();
    }


  }
});