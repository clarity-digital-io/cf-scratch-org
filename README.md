# Clarity Forms Salesforce App

## Dev, Build and Test
sfdx force:auth:web:login --setdefaultdevhubusername --setalias clarity-hub-org

sfdx force:org:list --all

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias clarity-forms-org

sfdx force:alias:set forms=test-e7cmxwaxbtza@example.com

sfdx force:config:set defaultusername=forms

sfdx force:source:push

sfdx force:org:open

sfdx force:user:password:generate --targetusername forms

sfdx force:user:display --targetusername forms

## commonly used commands

sfdx force:apex:trigger:create -n ClarityFormResponseTrigger -d force-app/main/default/triggers

sfdx force:lightning:component:create --type aura -n FormResponseView -d force-app/main/default/aura

sfdx force:lightning:component:create --type aura -n FormAnswersTable -d force-app/main/default/aura

sfdx force:lightning:component:create --type aura -n FormResponseCard -d force-app/main/default/aura

sfdx force:lightning:event:create -n FormResponseEvent -d force-app/main/default/aura

sfdx force:apex:class:create -n FormResponseLimits -d force-app/main/default/classes

## Tests

### Clarity_Form_QuestionTriggerHandler

F - sfdx force:apex:class:create -n AuditLogBuilderServiceTest -d force-app/main/default/classes

### Clarity_Form_ResponseTriggerHandler

P - sfdx force:apex:class:create -n FormResponseAssignmentTest -d force-app/main/default/classes

P - sfdx force:apex:class:create -n CreateResponseAnswersTest -d force-app/main/default/classes

### Clarity_Form_ConnectionTriggerHandler

sfdx force:apex:class:create -n ConnectionRecordProcessTest -d force-app/main/default/classes

sfdx force:apex:class:create -n ConnectionCreateJobTest -d force-app/main/default/classes

sfdx force:apex:class:create -n ConnectionFieldValidationTest -d force-app/main/default/classes

### Service Tests

sfdx force:apex:class:create -n ClarityFormBuilderTest -d force-app/main/default/classes

sfdx force:apex:class:create -n ClarityFormResponseTest -d force-app/main/default/classes

sfdx force:apex:class:create -n ClarityFormsExternalControllerTest -d force-app/main/default/classes

sfdx force:apex:class:create -n ClarityFormsOfflineControllerTest -d force-app/main/default/classes

sfdx force:apex:class:create -n ClarityFormsServiceTest -d force-app/main/default/classes

sfdx force:apex:class:create -n FormControllerTest -d force-app/main/default/classes

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


