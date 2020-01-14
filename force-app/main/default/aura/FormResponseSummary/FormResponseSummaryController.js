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

                cmp.set('v.form', form); 

            }
        }); 

        $A.enqueueAction(action);

    },
    edit: function(cmp, event, helper) {

        var workspaceAPI = cmp.find("workspace");

        workspaceAPI.openTab({
            pageReference: {
                type: "standard__component",
                attributes: {
                    componentName: "c__FormBuilder"
                },
                state: {
                    c__recordId: cmp.get("v.recordId"),
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
    // clone: function(cmp, event, helper) {

    //     let action = cmp.get("c.cloneForm");

    //     action.setParams({
    //         recordId: cmp.get("v.recordId")
    //     });

	// 	action.setCallback(this, function (response) {

    //         let state = response.getState();
        
    //         if (state === "SUCCESS") {
            
    //             var formId = response.getReturnValue();

    //             let navLink = cmp.find("navService");

    //             let pageRef = {
    //                 type: "standard__recordPage",
    //                 attributes: {
    //                     actionName: 'view', 
    //                     objectApiName: 'forms__Form__c', 
    //                     recordId: formId   
    //                 }
    //             }
        
    //             navLink.navigate(pageRef, true);

    //         } 
            
    //     }); 

    //     $A.enqueueAction(action);

    // }, 
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
                        objectApiName: 'forms__Form__c',
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
            ["c:FormResponse", { "formName": cmp.get("v.form.Name") }]
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