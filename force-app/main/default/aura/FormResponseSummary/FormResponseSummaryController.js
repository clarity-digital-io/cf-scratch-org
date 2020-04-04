({
    doInit: function(cmp, event, helper) {

        let action = cmp.get("c.getForm");

        action.setParams({
            recordId: cmp.get("v.recordId")
        });

		    action.setCallback(this, function (response) {

            let state = response.getState();
        
            if (state === "SUCCESS") {
            
                var form = response.getReturnValue();
                console.log('form', form); 
                cmp.set('v.form', form); 

            }
        }); 

        $A.enqueueAction(action);

    },
    edit: function(cmp, event, helper) {
				
				window.open ('/forms/FormBuilderApp.app?recordId=' + cmp.get('v.recordId'),'_self',false)

    },
    delete: function(cmp, event, helper) {

        let action = cmp.get("c.deleteForm");

        action.setParams({
            recordId: cmp.get("v.recordId")
        });

		action.setCallback(this, function (response) {

            let state = response.getState();
        
            if (state === "SUCCESS") {
            
                var navService = cmp.find("navService");

                var pageReference = {
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'form__Clarity_Form__c',
                        actionName: 'home'
                    }
                };

                navService.navigate(pageReference);

            } else {

                cmp.find('notifLib').showNotice({
                    "variant": "error",
                    "header": "Error",
                    "title": "Failed to delete",
                    "message": response.getError()[0].message
                });
            }
            
        }); 

        $A.enqueueAction(action);

    },
    handlePublishForm: function(cmp, event, helper) {


        let action = cmp.get("c.publishForm");

        action.setParams({
            recordId: cmp.get("v.recordId")
        });

        cmp.set('v.loading', true); 

		action.setCallback(this, function (response) {

            let state = response.getState();
        
            cmp.set('v.loading', false); 

            if (state === "SUCCESS") {
            
                var form = response.getReturnValue();

                cmp.set('v.form', form); 

            }
        }); 

        $A.enqueueAction(action);

    },
    handleNewFormResponse: function(cmp, event, helper) {

        $A.createComponents([
            ["forms:FormResponse", { "formName": cmp.get("v.form.Name") }]
        ],
        function(components, status) {
            if (status === "SUCCESS") {

                let formResponse = components[0];

                cmp.find('overlayLib').showCustomModal({
                    header: cmp.get("v.form.Name"),
                    cssClass: "clarityModal",
                    body: formResponse, 
                    showCloseButton: true
                })

            }
        });

    },
})