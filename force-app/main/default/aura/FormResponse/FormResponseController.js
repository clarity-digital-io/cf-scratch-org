({
    doInit: function(cmp) {
        
        if(cmp.get('v.recordId') == 'default') {
            let pageRef = cmp.get("v.pageReference");

            if(pageRef) {
                let recordId = pageRef.state.c__recordId;
                cmp.set('v.formId', recordId)
            } else {
                cmp.set('v.formId', 'new');
            }

        }

        if(cmp.get('v.formName') == 'default') {
            let pageRef = cmp.get("v.pageReference");

            if(pageRef) {
                let formName = pageRef.state.c__formName;
                cmp.set('v.formName', formName)
            }

        }

    }
    
})