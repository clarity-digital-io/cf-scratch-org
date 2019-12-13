({  
    handleNewFormResponse: function(cmp, event, helper) {

        var useRecordId = cmp.get("v.useRecordId");

        var recordId = cmp.get("v.recordId");

        var sObjectType = cmp.get("v.sobjecttype");

        $A.createComponents([
            ["c:FormResponse", { "formName": cmp.get("v.formName"), "useRecordId": useRecordId, "sObjectType": sObjectType, "sObjectId": recordId }]
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
})
