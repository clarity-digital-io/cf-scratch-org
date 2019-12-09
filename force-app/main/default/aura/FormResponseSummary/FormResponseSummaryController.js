({
    doInit: function(cmp, event, helper) {

        // cmp.set('v.columns', [{label: 'Name', fieldName: 'Name', type: 'text'}]);

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

        var workspaceAPI = cmp.find("workspace");

        workspaceAPI.openTab({
            pageReference: {
                type: "standard__component",
                attributes: {
                    recordId: cmp.get("v.recordId"),
                    componentName: "c__FormBuilder"
                }
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
        }).then(function(tabInfo) {
            console.log("The recordId for this tab is: " + tabInfo.recordId);
        })
        }).catch(function(error) {
            console.log(error);
        });

    },
    clone: function(cmp, event, helper) {

        let action = cmp.get("c.cloneForm");

        action.setParams({
            recordId: cmp.get("v.recordId")
        });

		action.setCallback(this, function (response) {

            let state = response.getState();
        
            if (state === "SUCCESS") {
            
                var formId = response.getReturnValue();

                let navLink = cmp.find("navService");

                let pageRef = {
                    type: "standard__recordPage",
                    attributes: {
                        actionName: 'view', 
                        objectApiName: 'Clarity_Form__c', 
                        recordId: formId   
                    }
                }
        
                navLink.navigate(pageRef, true);

            } 
            
        }); 

        $A.enqueueAction(action);

    }, 
    delete: function(cmp, event, helper) {

        let action = cmp.get("c.deleteForm");

        action.setParams({
            recordId: cmp.get("v.recordId")
        });

		action.setCallback(this, function (response) {

            let state = response.getState();
        
            if (state === "SUCCESS") {
            
            } 
            
        }); 

        $A.enqueueAction(action);

    },
    handlePublishForm: function(cmp, event, helper) {

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