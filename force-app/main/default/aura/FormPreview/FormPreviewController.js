({
    doInit: function(cmp) {

        if(cmp.get('v.recordId') == 'default') {

            if(cmp.get("v.pageReference") != null) {
                cmp.set('v.recordId', cmp.get("v.pageReference").state.c__recordId);
            } else {
                cmp.set('v.recordId', 'a0B4F000001WlTvUAK');
                return; 
            }

        }

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
    
})