({
    doInit: function(cmp) {

        if(cmp.get('v.recordId') == 'default') { 
            
            let pageRef = cmp.get("v.pageReference");

            if(pageRef) {
                let formId = pageRef.state.c__formId;
                cmp.set('v.formId', formId);

                let preview = pageRef.state.c__preview;
                cmp.set('v.preview', preview);

                let workspaceAPI = cmp.find("workspace");

                workspaceAPI.getTabInfo().then(function(response) {
                    let focusedTabId = response.tabId;
                    workspaceAPI.setTabLabel({
                        tabId: focusedTabId,
                        label: "Preview",
                    });
        
                    workspaceAPI.setTabIcon({
                        tabId: focusedTabId,
                        icon: "action:preview",
                        iconAlt: "Preview"
                    });
                })
                .catch(function(error) {
                    console.log(error);
                });
                
            } 

        }

    }
    
})