({
    doInit: function(cmp) {
        
        if(cmp.get('v.recordId') == 'default') {
            let pageRef = cmp.get("v.pageReference");
            let recordId = pageRef.state.c__recordId;
            cmp.set('v.recordId', recordId)
        }

        if(cmp.get('v.formName') == 'default') {
            let pageRef = cmp.get("v.pageReference");
            let formName = pageRef.state.c__formName;
            cmp.set('v.formName', formName)
        }

    }
    
})