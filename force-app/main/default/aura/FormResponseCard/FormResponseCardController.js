({  
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

    }
})
