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
    -n "Beta 2020" \
    -v "1.2" \
    -d "Managed beta release. Uploaded via the CLI" \
    -u PkgOrg \
    -w 15

sfdx force:package1:version:list -u PkgOrg

sfdx force:package:install \
    -p 04t6g000008OMW4AAO \
    -u formsPkgTest \
    -w 15

sfdx force:user:permset:assign -u formsPkgTest -n "Clarity_Forms_Builder"

sfdx force:package:version:promote --package "ClarityForms@1.0"

## Dev, Build and Test
sfdx force:auth:web:login --setdefaultdevhubusername --setalias clarity-force-devhub

sfdx force:org:list --all

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias mobile --durationdays 30 //clarity-forms-pkg

sfdx force:alias:set mobile=test-vsjzhlogmd0n@example.com

sfdx force:config:set defaultusername=mobile

sfdx force:source:push -f

sfdx force:org:open -u PkgOrg

sfdx force:user:password:generate --targetusername mobile

sfdx force:user:display --targetusername mobile

sfdx force:org:delete -u test-vsjzhlogmd0n@example.com

## Mobile Settings Controller Should:

- get company information (sandbox + company)
- check user permission (clarity forms mobile)
- get user info 

## Tests

## Security Checks 

sfdx force:apex:class:create -n Forms -d force-app/main/default/classes

sfdx force:apex:class:create -n IForms -d force-app/main/default/classes

sfdx force:apex:class:create -n Questions -d force-app/main/default/classes

sfdx force:apex:class:create -n IQuestions -d force-app/main/default/classes

sfdx force:apex:class:create -n Responses -d force-app/main/default/classes

sfdx force:apex:class:create -n IResponses -d force-app/main/default/classes


sfdx force:apex:class:create -n FormsSelector -d force-app/main/default/classes

sfdx force:apex:class:create -n IFormsSelector -d force-app/main/default/classes

sfdx force:apex:class:create -n QuestionsSelector -d force-app/main/default/classes

sfdx force:apex:class:create -n ResponsesSelector -d force-app/main/default/classes

sfdx force:apex:class:create -n IResponsesSelector -d force-app/main/default/classes

sfdx force:apex:class:create -n Application -d force-app/main/default/classes

sfdx force:apex:class:create -n IFormsService -d force-app/main/default/classes

sfdx force:apex:class:create -n FormsServiceImpl -d force-app/main/default/classes

sfdx force:apex:class:create -n QuestionsSelector -d force-app/main/default/classes

sfdx force:apex:class:create -n IQuestionsSelector -d force-app/main/default/classes


sfdx force:apex:class:create -n ResponsesResource -d force-app/main/default/classes

sfdx force:apex:class:create -n ResponsesService -d force-app/main/default/classes

sfdx force:apex:class:create -n ResponsesServiceImpl -d force-app/main/default/classes

sfdx force:apex:class:create -n IResponsesService -d force-app/main/default/classes

sfdx force:apex:class:create -n AnswersSelector -d force-app/main/default/classes

sfdx force:apex:class:create -n IAnswersSelector -d force-app/main/default/classes

sfdx force:apex:class:create -n Response -d force-app/main/default/classes

sfdx force:apex:class:create -n Answer -d force-app/main/default/classes

sfdx force:apex:class:create -n SObjectsResource -d force-app/main/default/classes/restapi

## Question_Option__c

sfdx force:apex:class:create -n QuestionsService -d force-app/main/default/classes/services

sfdx force:apex:class:create -n QuestionsServiceImpl -d force-app/main/default/classes/services

sfdx force:apex:class:create -n IQuestionsService -d force-app/main/default/classes/services


sfdx force:apex:class:create -n QuestionOptionsSelector -d force-app/main/default/classes/selectors

sfdx force:apex:class:create -n IQuestionOptionsSelector -d force-app/main/default/classes/selectors

## Question_Criteria__c

sfdx force:apex:class:create -n QuestionCriteriaSelector -d force-app/main/default/classes/selectors

sfdx force:apex:class:create -n IQuestionCriteriaSelector -d force-app/main/default/classes/selectors

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


## Rearchitect 

# UI/Front End Layer

- Used to build forms and create form responses
Form Builder
Form Response 
Form Mobile Application 

- Used for reviewing and setup
Form Summary 
Form Response View
Form Response Results


# Service Layer
FormService.cls
FormBuilder.cls
FormController.cls
FormResponse.cls

MobileFormController
MobileRecordController
MobileResponseController
MobileService

# Domain Layer
Form_ConnectionTriggerHandler.cls
QuestionTriggerHandler.cls
ResponseTriggerHandler.cls
ConnectionCreateJob.cls
ConnectionFieldValidation.cls
ConnectionRecordProcess.cls
QuestionFlowDesigns

# Selector Layer
Form__c
Response__c
Answer__c
Form_Connection__c
Form_Connection_Field__c
Form_Connection_Process__c
Question__c
Question_Criteria__c
Question_Filter__c
Flow__c
Flow_Design__c
Question_Option__c
Response_Connection__c