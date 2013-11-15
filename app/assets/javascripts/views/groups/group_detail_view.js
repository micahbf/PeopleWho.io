BT.Views.GroupDetailView = Backbone.View.extend({
  template: JST['groups/detail'],

  events: {
    "click #leave-group-btn": "leaveGroup",
    "click #add-new-member-btn": "addNewMemberForm",
    "blur #new-member-input": "addNewMember"
  },

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
  },

  addNewMemberForm: function(event) {
    event.preventDefault();

    $newMemberInput = $("<input type='text' id='new-member-input' placeholder='name or email'>");
    this.$el.find("#add-new-member-btn").before($newMemberInput);
    $newMemberInput.autocomplete({ source: BT.userAutocompletes });
    $newMemberInput.focus();
  },

  addNewMember: function(event) {
    event.preventDefault();
    var currentMemberIds = this.model.get("user_ids");
    var newMemberIdent = $(event.target).val();

    var user = BT.users.find(function (user) {
      return (user.get("email") === newMemberIdent ||
              user.get("name") === newMemberIdent);
    });

    if (user !== undefined) {
      currentMemberIds.push(user.id);
      this.model.set("user_ids", currentMemberIds);
      this.model.save();
    }

    this.render();
  }
});