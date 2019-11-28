({
    handleViewResponse: function(cmp, event, recordId) {

        var workspaceAPI = cmp.find("workspace");

        workspaceAPI.openTab({
            pageReference: {
                type: "standard__recordPage",
                attributes: {
                    recordId: recordId,
                    objectApiName: "Clarity_Form_Response__c",
                    actionName: "view"
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
    handleEditResponse: function(cmp, event, recordId) {

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
    handleDeleteResponse: function(cmp, event, recordId) {

        cmp.set('v.loading', true);

        let action = cmp.get("c.deleteFormResponse");

        action.setParams({
            responseId: recordId
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
