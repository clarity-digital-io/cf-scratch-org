# Clarity Forms Salesforce App

## Custom Objects

### Clarity Form (Clarity_Form__c)

Name
OwnerId
Status__c (Draft, Published)
Background_Color__c
Question_Color__c
Button_Color__c
Font_Family__c

### Clarity Form Question (Clarity_Form_Question__c)

Name
Order__c
Required__c
Title__c
Initial__c 
Type__c (MultipleChoice, Comment, Star, Dropdown, Ranking, Slider, Date, Email, Payment, RecordGroup, Lookup)

### Clarity Form Flow Design (Clarity_Form_Flow_Design__c) (On Change or Form Submission )

Clarity_Form_Question__c
Active__c 
Form_Submission__c 
Values__c 

### Clarity Form Flow (Clarity_Form_Flow__c) (Created From ) (Batch Job to delete)

Clarity_Form_Question__c
Clarity_Form_Flow_Design__c
User
Value__c 
CreatedDate

### Clarity Form Question Option (Clarity_Form_Question_Option__c)

Clarity_Form_Question__c
Name
Label__c

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

## Dev, Build and Test
sfdx force:org:list

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias clarity-scratch-org

sfdx force:alias:set YourAlias=test-atjutk9l63p1@example.com

sfdx force:user:password:generate --targetusername test-atjutk9l63p1@example.com

sfdx force:user:display --targetusername test-atjutk9l63p1@example.com

sfdx force:config:set defaultusername=test-atjutk9l63p1@example.com

sfdx force:source:push

## Resources


## Description of Files and Directories


## Issues


## clarity-scratch-org 


