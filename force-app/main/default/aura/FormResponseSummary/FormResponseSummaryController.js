({
    doInit: function(cmp, event, helper) {

        

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
