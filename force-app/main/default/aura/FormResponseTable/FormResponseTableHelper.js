({
    getFormResponses: function(cmp, event) {
        
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
    getRowActions: function(cmp, row, doneCallback) {

        var viewAction = {
            label: 'View',
            name: 'View',
            title: 'View',
            variant: 'Brand',
            disabled: false,
            value: 'view',
            iconPosition: 'left'
        }

        var editAction = {
            label: 'Edit',
            name: 'Edit',
            title: 'Edit',
            disabled: false,
            value: 'edit',
            iconPosition: 'left'
        }

        var deleteAction = {
            label: 'Delete',
            name: 'Delete',
            title: 'Delete',
            variant: 'Destructive',
            disabled: false,
            value: 'delete',
            iconPosition: 'left'
        };

        var actions = [];

        if (row.status == 'Submitted') {
            actions.push(viewAction);
            editAction.disabled = true;
            actions.push(editAction);
        } else {
            viewAction.disabled = true;
            actions.push(viewAction);
            actions.push(editAction);
        }

        actions.push(deleteAction);

        doneCallback(actions);

    },
    handleViewResponse: function(cmp, event, record) {

        var workspaceAPI = cmp.find("workspace");

        workspaceAPI.openTab({
            pageReference: {
                type: "standard__recordPage",
                attributes: {
                    recordId: record.id,
                    objectApiName: "Clarity_Form_Response__c",
                    actionName: "view"
                }
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
        }).then(function(tabInfo) {

        })
        }).catch(function(error) {

        });


    },
    handleEditResponse: function(cmp, event, record) {

        $A.createComponents([
            ["c:FormResponse", { "formName": record.name, "recordId": record.id }]
        ],
        function(components, status) {
            if (status === "SUCCESS") {

                let formResponse = components[0];

                cmp.find('overlayLib').showCustomModal({
                    header: cmp.get("v.formName"),
                    cssClass: "clarityModal",
                    body: formResponse, 
                    showCloseButton: true
                })

            }
        });

    },
    handleDeleteResponse: function(cmp, event, record) {

        cmp.set('v.loading', true);

        let action = cmp.get("c.deleteFormResponse");

        action.setParams({
            responseId: record.id
        });

		action.setCallback(this, function (response) {

			let state = response.getState();

			if (state === "SUCCESS") {

                let deletedId = response.getReturnValue(); 

                let data = cmp.get('v.data');

                let responses = data.filter(r => r.id != deletedId);

                cmp.set('v.data', responses);

                cmp.set('v.loading', false);

			} else if (state === "ERROR") {

                cmp.set('v.loading', false);

				let errors = response.getError();

                cmp.find('notifLib').showToast({
                    "variant": "error",
                    "title"  : "Error!",
                    "message": response.getError()
                });

			}

        });
        
        $A.enqueueAction(action);

    }
})
