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

    }, 
    delete: function(cmp, event, helper) {

    }
})


//Josue Code //  
({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Name', fieldName: 'name', type: 'text'}]
        )}})