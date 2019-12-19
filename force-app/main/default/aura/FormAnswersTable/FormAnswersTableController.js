({
    doInit: function(cmp, event, helper) {

        let action = cmp.get("c.getAnswerColumns");

        action.setParams({
            recordId: cmp.get("v.recordId")
        });

        cmp.set('v.loading', true); 

		action.setCallback(this, function (response) {

            let state = response.getState();
        
            if (state === "SUCCESS") {
            
                let table = response.getReturnValue();

                cmp.set('v.columns', table.Columns);

                cmp.set('v.data', table.Data);

            }

            cmp.set('v.loading', false); 

        }); 

        $A.enqueueAction(action);

    },
    handleRowAction: function(cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'editRecord':
                helper.editRecord(row);
                break;
            // You might have other buttons as well, handle them in the same way
            case 'action2':
                helper.handleAction2(cmp, row, action);
                break;
            // etc.
        }
    }
})
