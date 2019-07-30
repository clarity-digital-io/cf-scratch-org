# Clarity Forms Salesforce App

## Custom Objects

### Clarity Form (Clarity_Form__c)

Name
OwnerId
Status__c (Draft, Published)
Clarity_Form_Style__c
Clarity_Form_Assignment__c

### Clarity Form Style (Clarity_Form_Style__c)

Name
Background_Color__c
Question_Color__c
Button_Color__c
Font_Family__c

## Clarity Form Assignment (Clarity_Form_Assignment__c)

Name
Assign__c
Default_Assign__c

### Clarity Form Assignment Rule (Clarity_Form_Assignment_Rule__c)

Name
Clarity_Form_Assignment__c
Field__c
Field_Type__c
Operator__c
Type__c
Value__c

### Clarity Form Question (Clarity_Form_Question__c)

Name
Order__c
Required__c
Title__c
Initial__c 
Type__c (MultipleChoice, Comment, Star, Dropdown, Ranking, Slider, Date, Email, Payment, RecordGroup, Lookup)

### Clarity Form Question Flow Design (Clarity_Form_Question_Flow_Design__c) (On Change or Form Submission )

Clarity_Form_Question__c
Active__c 
Form_Submission__c 
Values__c 

### Clarity Form Question Flow (Clarity_Form_Question_Flow__c) (Created From ) (Batch Job to delete)

Clarity_Form_Question__c
Clarity_Form_Flow_Design__c
User
Value__c 

### Clarity Form Question Option (Clarity_Form_Question_Option__c)

Clarity_Form_Question__c
Name
Label__c

### Clarity Form Question Record Field (Clarity_Form_Question_Record_Field__c)

Clarity_Form_Question__c
Field__c

### Clarity Form Response (Clarity_Form_Response__c)

OwnerId
Clarity_Form__c
Completion__c (70%)
Status__c (New, In Progress, Submitted)
Time__c (2:30)

### Clarity Form Answer (Clarity_Form_Answer__c)

Clarity_Form_Question__c
Record__c (LookupId to record created)
Answer__c 

### Clarity Form Question Criteria 

Clarity_Form_Question__c
Field__c
Operator__c
Type__c
Value__c

SHOW 

When

FIELD           OPERATOR            TYPE            VALUE
Initial         EQUALS              REFERENCE       Opportunity.Probability  
Question1       GREATER THAN        REFERENCE       Opportunity.Probability
Question2       EQUALS              String          'Option 1'

### Clarity Form Response Submit 

On Submit

After Clearing UI Validation Checks (Required and Others...)

Checks Required

- Input Flows
- Assignments
- Connections

## Dev, Build and Test
sfdx force:auth:web:login --setdefaultdevhubusername --setalias clarity-hub-org

sfdx force:org:list

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias clarity-scratch-org

sfdx force:alias:set dev=test-f8d3cxy7bv6u@example.com

sfdx force:config:set defaultusername=dev

sfdx force:source:push

sfdx force:org:open

sfdx force:user:password:generate --targetusername dev

sfdx force:user:display --targetusername dev

## commonly used commands

sfdx force:apex:trigger:create -n ClarityFormResponseTrigger -d force-app/main/default/triggers

sfdx force:apex:class:create -n CreateResponseAnswersTest -d force-app/main/default/classes

sfdx force:lightning:component:create --type aura -n FormResponseTable -d force-app/main/default/aura

sfdx force:lightning:component:create --type aura -n FormResponseTimeline -d force-app/main/default/aura

sfdx force:lightning:component:create --type aura -n FormResponseModalFooter -d force-app/main/default/aura

sfdx force:lightning:component:create --type aura -n FormResponseSummary -d force-app/main/default/aura

sfdx force:lightning:event:create -n FormResponseEvent -d force-app/main/default/aura

sfdx force:apex:class:create -n FormResponseController -d force-app/main/default/classes

## Resources


## Description of Files and Directories


## Issues


## clarity-scratch-org 

## Use Cases
Digital Signatures Approval Process
Add filtering on the Lookups by Record Type and other fields
Add RecordType select on Record Group

Timeline

ResponsesTable

FormResponse - (New, Edit, Submitted, Locked)

***Decrease bundle.js below 400kb



