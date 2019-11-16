({
    doInit: function(cmp, event, helper) {

        cmp.set('v.columns', [{label: 'Name', fieldName: 'Name', type: 'text'}]);

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

                let data = form.Clarity_Form_Responses__r.map(res => {
                    return { id: res.Id, name: res.Name, status: res.Status__c, completed: '', start: res.CreatedDate, submittedDate: '' }
                });

                cmp.set('v.data', data);

            }
        }); 

        $A.enqueueAction(action);

    },
    edit: function(cmp, event, helper) {

        let navLink = cmp.find("navService");

        let pageRef = {
            type: "standard__component",
            attributes: {
                componentName: "c__FormBuilder"    
            },    
            state: {
                c__recordId: cmp.get("v.recordId")    
            }
        }

        navLink.navigate(pageRef, true);

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
    handleNewFormResponseTab: function(cmp, event, helper) {

        let navLink = cmp.find("navService");
        console.log('CF', cmp.get("v.form.Name"));
        let pageRef = {
            type: "standard__component",
            attributes: {
                componentName: "c__FormResponseView"    
            },    
            state: {
                c__formName: cmp.get("v.form.Name")
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
                console.log('responses', responses); 
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