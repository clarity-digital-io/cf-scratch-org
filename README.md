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

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias mobile-test-prod-one --durationdays 30 //clarity-forms-pkg

sfdx force:alias:set mobile-test-prod-one=test-fbyfuujmm9zd@example.com

sfdx force:config:set defaultusername=mobile-test-prod-one

sfdx force:source:push -f

sfdx force:org:open -u PkgOrg

sfdx force:user:password:generate --targetusername mobile-test-prod-one

sfdx force:user:display --targetusername mobile-test-prod-one

sfdx force:org:delete -u test-fbyfuujmm9zd@example.com

## Mobile Settings Controller Should:

- get company information (sandbox + company)
- check user permission (clarity forms mobile)
- get user info 

## Tests

sfdx force:lightning:component:create -n WizardMobileSetup -d force-app/main/default/aura --type aura

sfdx force:apex:class:create -n WizardController -d force-app/main/default/classes/controllers

## Security Checks 

sfdx force:apex:class:create -n ResponseConnectionsService -d force-app/main/default/classes/services
sfdx force:apex:class:create -n IResponseConnectionsService -d force-app/main/default/classes/services
sfdx force:apex:class:create -n ResponseConnectionsServiceImpl -d force-app/main/default/classes/services
sfdx force:apex:class:create -n ResponseConnectionsSelector -d force-app/main/default/classes/selectors
sfdx force:apex:class:create -n IResponseConnectionsSelector -d force-app/main/default/classes/selectors

sfdx force:apex:class:create -n AnswersService -d force-app/main/default/classes/services
sfdx force:apex:class:create -n IAnswersService -d force-app/main/default/classes/services
sfdx force:apex:class:create -n AnswersServiceImpl -d force-app/main/default/classes/services

ContentVersion

sfdx force:apex:class:create -n ContentVersions -d force-app/main/default/classes/domains
sfdx force:apex:class:create -n IContentVersions -d force-app/main/default/classes/domains

sfdx force:apex:class:create -n Answers -d force-app/main/default/classes/domains
sfdx force:apex:class:create -n IAnswers -d force-app/main/default/classes/domains


sfdx force:apex:class:create -n ImagesHelper -d force-app/main/default/classes/controllers/helpers

sfdx force:apex:class:create -n PicklistHelper -d force-app/main/default/classes/controllers/helpers


sfdx force:apex:class:create -n MobileSyncTrigger -d force-app/main/default/classes/controllers


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
