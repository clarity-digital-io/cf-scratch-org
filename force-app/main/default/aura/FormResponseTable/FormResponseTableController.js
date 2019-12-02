({  
    init: function(cmp, event, helper) {

        var rowActions = helper.getRowActions.bind(this, cmp);

        cmp.set('v.columns', [
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'Status', fieldName: 'status', type: 'text'}, 
            {label: 'Percentage Complete', fieldName: 'completed', type: 'text'},
            {label: 'Start Date', fieldName: 'start', type: 'date'}, 
            {label: 'Submitted Date', fieldName: 'submittedDate', type: 'date'}, 
            { type: 'action', typeAttributes: { rowActions: rowActions } }
        ])

        helper.getFormResponses(cmp, event);

    },
    viewRecord: function(cmp, event, helper) {

        var recordId = event.getParam('row').id;
        var actionName = event.getParam('action').name;

        switch (actionName) {
            case 'View':
                helper.handleViewResponse(cmp, event, recordId);
                break;
            case 'Edit':
                helper.handleEditResponse(cmp, event, recordId);
                break;
            case 'Delete':
                helper.handleDeleteResponse(cmp, event, recordId);
                break;    
            default:
                break;
        }
    },
    handleFormResponseEvent: function(cmp, event, helper) {

        helper.getFormResponses(cmp, event);

    }
})
