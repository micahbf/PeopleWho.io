BT.Models.User = Backbone.Model.extend({
  collection: BT.Collections.Users,
  
  displayName: function () {
    if (this.get("name")) {
      return this.escape("name");
    } else {
      return this.escape("email");
    }
  },

  parse: function(serverAttrs) {
    return serverAttrs.user;
  },

  settle: function (successCallback, callbackBinding) {
    var self = this;

    this.attributes.bill_splits.unshift({
      amount: this.get("balance"),
      debtor_id: CURRENT_USER_ID,
      bill: {
        total: this.get("balance"),
        settling: true,
        created_at: moment().toISOString()
      }
    });

    this.set({ balance: 0 });
    delete BT.balances[this.id];

    $.ajax({
      url: "/api/users/" + this.id + "/settle",
      type: "post",
      success: function () {
        successCallback.call(callbackBinding, self);
      }
    });
  }
});