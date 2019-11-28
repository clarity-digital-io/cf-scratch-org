({  
    init: function(cmp, event, helper) {

        cmp.set('v.columns', [
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'Status', fieldName: 'status', type: 'text'}, 
            {label: 'Percentage Complete', fieldName: 'completed', type: 'text'},
            {label: 'Start Date', fieldName: 'start', type: 'date'}, 
            {label: 'Submitted Date', fieldName: 'submittedDate', type: 'date'}, 
            {type: "button", typeAttributes: {
                label: 'View',
                name: 'View',
                title: 'View',
                variant: 'Brand',
                disabled: false,
                value: 'view',
                iconPosition: 'left'
            }},
            {type: "button", typeAttributes: {
                label: 'Edit',
                name: 'Edit',
                title: 'Edit',
                disabled: false,
                value: 'edit',
                iconPosition: 'left'
            }},
            {type: "button", typeAttributes: {
                label: 'Delete',
                name: 'Delete',
                title: 'Delete',
                variant: 'Destructive',
                disabled: false,
                value: 'delete',
                iconPosition: 'left'
            }}
        ])

        cmp.set('v.loading', true);

        let action = cmp.get("c.getFormResponses");

        action.setParams({
            formId  : cmp.get("v.formId"),
            name    : cmp.get("v.formName") ? cmp.get("v.formName") : ''
        })

		action.setCallback(this, function (response) {

			let state = response.getState();

			if (state === "SUCCESS") {

                cmp.set('v.loading', false);

                console.log(response.getReturnValue());

                let data = response.getReturnValue(); 

                let responses = data.map(response => {
                    return {
                        name          : response.Name,
                        status        : response.Status__c, 
                        completed     : response.Completion__c ? response.Completion__c : '0%',
                        start         : response.CreatedDate, 
                        submittedDate : response.Submitted_Date__c ? response.Submitted_Date__c : '',
                        id            : response.Id
                    }
                })

                cmp.set('v.data', responses);

                cmp.set('v.loading', false);

			} else if (state === "ERROR") {

				let errors = response.getError();

                cmp.find('notifLib').showToast({
                    "variant": "error",
                    "title"  : "Error!",
                    "message": response.getError()
                });

			}

		});

        $A.enqueueAction(action);
    },
    viewRecord: function(cmp, event, helper) {

        var recordId = event.getParam('row').Id;
        var actionName = event.getParam('action').name;

        switch (actionName) {
            case 'view':
                helper.handleViewResponse(cmp, event, recordId);
                break;
            case 'edit':
                helper.handleEditResponse(cmp, event, recordId);
                break;
            case 'delete':
                helper.handleDeleteResponse(cmp, event, recordId);
                break;    
            default:
                break;
        }
    }
})
