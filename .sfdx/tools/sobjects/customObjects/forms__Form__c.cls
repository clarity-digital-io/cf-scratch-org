// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class forms__Form__c {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String Name;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global forms__Checklist_Group__c forms__Checklist_Group__r;
    global Id forms__Checklist_Group__c;
    global String forms__Connected_Object__c;
    global String forms__Description__c;
    global Date forms__End_Date__c;
    global Boolean forms__Has_Thank_You__c;
    global String forms__Label__c;
    global String forms__Multi_Page_Info__c;
    global Boolean forms__Multi_Page_Val__c;
    global Boolean forms__Multi_Page__c;
    global Double forms__Responses_Completed__c;
    global Double forms__Responses_Started__c;
    global String forms__Status__c;
    global String forms__Thank_You_Redirect__c;
    global String forms__Title__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<forms__Form_Connection__c> forms__Form_Connections__r;
    global List<forms__Form__Share> Shares;
    global List<forms__Question__c> forms__Questions__r;
    global List<forms__Response__c> forms__Responses__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global forms__Form__c () 
    {
    }
}