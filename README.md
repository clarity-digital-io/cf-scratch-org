# Clarity Forms Salesforce App

## Packaging
sfdx force:auth:web:login -a PkgOrg

```
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true
    }
  ],
  "namespace": "YOUR_NS_HERE",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "44.0"
}
```

sfdx force:org:create -a forms-pkg -s -f config/project-scratch-def.json

sfdx force:org:create -a formsPkgTest -n -f config/project-scratch-def.json

sfdx force:org:open -u formsPkgTest

sfdx force:source:convert \
    -d mdapi-source/updated-package \
    -n "Clarity Forms"

sfdx force:mdapi:deploy \
    -d mdapi-source/updated-package \
    -u PkgOrg \
    -l NoTestRun \
    -w 15

    NoTestRun
    RunLocalTests

>>>>>> here is where we are
sfdx force:package1:version:create \
    -i 0336g00000061bb \
    -n "Alpha 2020" \
    -v "1.1" \
    -d "Managed beta release. Uploaded via the CLI" \
    -u PkgOrg \
    -w 15

sfdx force:package1:version:list -u PkgOrg

sfdx force:package:install \
    -p 04t6g000005qGoVAAU \
    -u formsPkgTest \
    -w 15

sfdx force:user:permset:assign -u formsPkgTest -n "Clarity_Forms_Builder"

sfdx force:package:version:promote --package "ClarityForms@1.0"

## Dev, Build and Test
sfdx force:auth:web:login --setdefaultdevhubusername --setalias clarity-force-devhub

sfdx force:org:list --all

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias CF-38 -d 30 //clarity-forms-pkg

sfdx force:alias:set CF-38=test-rkoxzz1zrsvb@example.com

sfdx force:config:set defaultusername=CF-38

sfdx force:source:push -f

sfdx force:org:open -u PkgOrg

sfdx force:user:password:generate --targetusername CF-38

sfdx force:user:display --targetusername CF-38

sfdx force:org:delete -u test-kcokhvynzqxr@example.com

## commonly used commands

sfdx force:apex:trigger:create -n ClarityFormResponseTrigger -d force-app/main/default/triggers

sfdx force:lightning:component:create --type aura -n FormResponseView -d force-app/main/default/aura

sfdx force:lightning:component:create --type aura -n FormHeader -d force-app/main/default/aura

sfdx force:lightning:component:create --type aura -n FormAnswersTable -d force-app/main/default/aura

sfdx force:lightning:component:create --type aura -n FormResponseCard -d force-app/main/default/aura

sfdx force:lightning:event:create -n FormResponseEvent -d force-app/main/default/aura

sfdx force:apex:class:create -n FormResponseLimits -d force-app/main/default/classes

sfdx force:lightning:component:create --type lwc -n formAnswers -d force-app/main/default/lwc

sfdx force:lightning:component:create --type lwc -n imageAnswersTable -d force-app/main/default/lwc

sfdx force:lightning:component:create --type lwc -n imageControl -d force-app/main/default/lwc

sfdx force:apex:class:create -n ConnectionFieldValidationTest -d force-app/main/default/classes

sfdx force:apex:class:create -n ClarityFormBuilderTest -d force-app/main/default/classes


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

## Creating a managed package

https://sfdx-isv.github.io/sfdx-workshop/

- Environment Hub
- Create new Partner Developer Org

## CRUD and FLS Security

DMLManager.insert
DMLManager.update
DMLManager.upsert
DMLManager.delete
DMLManager.query

sfdx force:apex:class:create -n DMLManager -d force-app/main/default/classes

## sObjects
Clarity_Form__c
Clarity_Form_Answer__c
Clarity_Form_Assignment__c
Clarity_Form_Assignment_Rule__c
Clarity_Form_Audit_Log__c
Clarity_Form_Connection__c
Clarity_Form_Connection_Field__c
Clarity_Form_Connection_Process__c
Clarity_Form_Question__c
Clarity_Form_Question_Criteria__c
Clarity_Form_Question_Filter__c
Clarity_Form_Question_Flow__c
Clarity_Form_Question_Flow_Design__c
Clarity_Form_Question_Option__c
Clarity_Form_Response__c
Clarity_Form_Response_Connection__c
Clarity_Form_Style__c