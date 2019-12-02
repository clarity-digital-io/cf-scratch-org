({
    doInit: function(cmp, event, helper) {

        let action = cmp.get("c.getAnswerColumns");

        action.setParams({
            recordId: cmp.get("v.recordId")
        });

		action.setCallback(this, function (response) {

            let state = response.getState();
        
            if (state === "SUCCESS") {
            
                let table = response.getReturnValue();

                // let columns = table.Columns.map(column => {

                //     if(column.type == 'recordgroup') {

                //         let newColumn = {
                //             label : column.label, 
                //             fieldName : column.fieldName,
                //             type: 'button',
                //             typeAttributes: {
                //                 iconName: 'utility:view',
                //                 label: 'View Record',
                //                 name: 'viewRecord',
                //                 disabled: false,
                //                 value: 'viewBtn'
                //             }
                //         }

                //         return newColumn;
                //     }
                //     return column;
                // })

                cmp.set('v.columns', table.Columns);

                console.log('data', table.Columns, table.Data);
                cmp.set('v.data', table.Data);

            }
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
