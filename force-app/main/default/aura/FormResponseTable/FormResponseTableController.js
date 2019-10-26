({  
    init: function(cmp, event, helper) {

        cmp.set('v.loading', true);

        let action = cmp.get("c.getFormResponses");

        action.setParams({
            name: cmp.get("v.formName")
        })

		action.setCallback(this, function (response) {

			let state = response.getState();

			if (state === "SUCCESS") {

                cmp.set('v.loading', false);

                console.log(response.getReturnValue());

                let data = response.getReturnValue(); 

                let responses = data.map(response => {
                    return {
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
    handleNewFormResponse: function(cmp, event, helper) {

        $A.createComponents([
            ["c:FormResponse", { "formName": cmp.get("v.formName") }]
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
    handleNewFormResponseTab: function(cmp, event, helper) {

        let navLink = cmp.find("navService");
        console.log('CF', cmp.get("v.formName"));
        let pageRef = {
            type: "standard__component",
            attributes: {
                componentName: "c__FormResponse"    
            },    
            state: {
                c__formName: cmp.get("v.formName")
            }
        }

        navLink.navigate(pageRef, true);

    },
    handleEditFormResponse: function(cmp, event, helper) {

        let recordId = event.getSource().get("v.value");

        $A.createComponents([
            ["c:FormResponse", { "formName": cmp.get("v.formName"), "recordId": recordId }]
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
    handleDeleteFormResponse: function(cmp, event, helper) {

        let id = event.getSource().get("v.value");

        cmp.set('v.loading', true);

        let action = cmp.get("c.deleteFormResponse");

        action.setParams({
            responseId: id
        });

		action.setCallback(this, function (response) {

			let state = response.getState();

			if (state === "SUCCESS") {

                cmp.set('v.loading', false);

                let deletedId = response.getReturnValue(); 

                let data = cmp.get('v.data');

                let responses = data.filter(r => r.Id != deletedId);

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

    }
})
