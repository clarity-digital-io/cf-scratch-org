({
    doInit: function(cmp) {

        if(cmp.get('v.recordId') == 'default') {
            cmp.set('v.recordId', cmp.get("v.pageReference").state.recordId);
        }

        let workspaceAPI = cmp.find("workspace");

        if(workspaceAPI != null) {

            workspaceAPI.getTabInfo().then(function(response) {
                let focusedTabId = response.tabId;
                workspaceAPI.setTabLabel({
                    tabId: focusedTabId,
                    label: `Form: ${cmp.get('v.recordId')}`,
                });
    
                workspaceAPI.setTabIcon({
                    tabId: focusedTabId,
                    icon: "action:preview",
                    iconAlt: "Form"
                });
            })
            .catch(function(error) {
                console.log(error);
            });
            
        }

    }
    
})