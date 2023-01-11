({
  doInit: function (cmp, event, helper) {
    helper.getOrganizationInformation(cmp, event);
  },
  setup: function (cmp, event, helper) {
    helper.getSetupInformation(cmp, event);
  },
  handleRefresh: function (cmp, event, helper) {
    helper.getSetupInformation(cmp, event);
  },
  handleAccess: function (cmp, event, helper) {
    window.open(
      "https://clarity-api-auth.herokuapp.com/",
      "CNN_WindowName",
      "resizable,scrollbars,status"
    );
  },
  handleConnect: function (cmp, event, helper) {
    let action = cmp.get("c.createConnect");

    action.setCallback(this, function (response) {
      let state = response.getState();

      if (state === "SUCCESS") {
        console.log(response.getReturnValue());
      }
    });

    $A.enqueueAction(action);
  },
  handleSyncUsers: function (cmp, event, helper) {
    let action = cmp.get("c.registerUsers");

    action.setCallback(this, function (response) {
      let state = response.getState();

      if (state === "SUCCESS") {
        console.log(response.getReturnValue());
      }
    });

    $A.enqueueAction(action);
  }
});
