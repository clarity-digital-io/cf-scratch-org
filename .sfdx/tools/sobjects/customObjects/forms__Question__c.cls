// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class forms__Question__c {
    global Id Id;
    global Boolean IsDeleted;
    global String Name;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global forms__Form__c forms__Form__r;
    global Id forms__Form__c;
    global forms__Question__c forms__Connected_Object__r;
    global Id forms__Connected_Object__c;
    global String forms__FreeText_Type__c;
    global String forms__Logic__c;
    global String forms__Lookup__c;
    global Double forms__Max_Length__c;
    global Double forms__Max_Range__c;
    global Double forms__Min_Range__c;
    global Double forms__Order__c;
    global Double forms__Page__c;
    global String forms__Prefill_Type__c;
    global forms__Question__c forms__Record_Group__r;
    global Id forms__Record_Group__c;
    global Boolean forms__Required__c;
    global String forms__Salesforce_Field__c;
    global String forms__Salesforce_Object__c;
    global Double forms__Step__c;
    global String forms__Title__c;
    global String forms__Type__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<ContentVersion> forms__Content_Versions__r;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<forms__Answer__c> forms__Answers__r;
    global List<forms__Flow_Design__c> forms__Flow_Designs__r;
    global List<forms__Flow__c> forms__Flows__r;
    global List<forms__Form_Connection_Field__c> forms__Form_Connection_Fields__r;
    global List<forms__Question_Criteria__c> forms__Question_Criteria__r;
    global List<forms__Question_Filter__c> forms__Question_Filters__r;
    global List<forms__Question_Option__c> forms__Question_Options__r;
    global List<forms__Question__c> forms__Clarity_Form_Questions__r;
    global List<forms__Question__c> forms__Clarity_Form_Questions1__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global forms__Question__c () 
    {
    }
}