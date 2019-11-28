({
    doInit: function(cmp, event, helper) {

        let action = cmp.get("c.getAnswerColumns");

        action.setParams({
            recordId: cmp.get("v.recordId")
        });

		action.setCallback(this, function (response) {

            let state = response.getState();
        
            if (state === "SUCCESS") {
            
                var table = response.getReturnValue();

                cmp.set('v.columns', table.Columns);
                cmp.set('v.data', table.Data);

            }
        }); 

        $A.enqueueAction(action);

    }
})
