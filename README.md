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

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias refactor --durationdays 30 //clarity-forms-pkg

sfdx force:alias:set refactor=test-5rv8cgdafulc@example.com

sfdx force:config:set defaultusername=refactor

sfdx force:source:push -f

sfdx force:org:open -u PkgOrg

sfdx force:user:password:generate --targetusername refactor

sfdx force:user:display --targetusername refactor

sfdx force:org:delete -u test-5rv8cgdafulc@example.com

## Mobile Settings Controller Should:

- get company information (sandbox + company)
- check user permission (clarity forms mobile)
- get user info 

## Tests

## Security Checks 

sfdx force:apex:class:create -n FLSUtility -d force-app/main/default/classes

sfdx force:apex:class:create -n DatabaseUtility -d force-app/main/default/classes


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
Clarity_Form_ConnectionTriggerHandler.cls
Clarity_Form_QuestionTriggerHandler.cls
Clarity_Form_ResponseTriggerHandler.cls
ConnectionCreateJob.cls
ConnectionFieldValidation.cls
ConnectionRecordProcess.cls
CreateResponseAnswers.cls
QuestionFlowDesigns

# Selector Layer

Clarity_Form__c => Form__c
Clarity_Form_Response__c => Response__c
Clarity_Form_Answer__c => Answer__c
Clarity_Form_Connection__c => Form_Connection__c
Clarity_Form_Connection_Field__c => Connection_Field__c
Clarity_Form_Connection_Process__c => Connection_Process__c
Clarity_Form_Question__c => Question__c
Clarity_Form_Question_Criteria__c => Question_Criteria__c
Clarity_Form_Question_Filter__c => Question_Filter__c
Clarity_Form_Question_Flow__c => Flow__c
Clarity_Form_Question_Flow_Design__c => Flow_Design__c
Clarity_Form_Question_Option__c => Question_Option__c
Clarity_Form_Response_Connection__c => Response_Connection__c