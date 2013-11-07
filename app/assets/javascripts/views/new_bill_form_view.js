BT.Views.NewBillFormView = Backbone.View.extend({
  template: JST['bills/form'],
  splitTemplate: JST['bills/form_bill_split'],
  splitCounter: 0,

  render: function () {
    var renderedForm = this.template();
    this.$splitsDiv = $(renderedForm).find("#bill-splits");
    this.addSplit();
    this.$el.html(renderedForm);  
    return this;
  },

  addSplit: function () {
    var renderedSplit = this.splitTemplate({
      splitNum: this.splitCounter
    });
    this.$splitsDiv.append(renderedSplit);
    this.splitCounter += 1;
  }
});