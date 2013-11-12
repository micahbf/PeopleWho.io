BT.Collections.Groups = Backbone.Collection.extend({
  url: "/api/groups",
  model: BT.Models.Group
});