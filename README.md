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

sfdx force:package1:version:create \
    -i 0336g0000005mgC \
    -n "Alpha 2020" \
    -v "1.0" \
    -d "Managed beta release. Uploaded via the CLI" \
    -u PkgOrg \
    -w 15

sfdx force:data:soql:query -q 'select ApexTestClass.Name, TestMethodName, ApexClassOrTrigger.Name, NumLinesUncovered, NumLinesCovered, Coverage from ApexCodeCoverage' -u forms-pkg -t -r csv > testcoverage.csv

## Dev, Build and Test
sfdx force:auth:web:login --setdefaultdevhubusername --setalias clarity-force-devhub

sfdx force:org:list --all

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias clarity-forms-org

sfdx force:alias:set forms=test-5dyeg6r1gyv9@example.com

sfdx force:config:set defaultusername=forms

sfdx force:source:push

sfdx force:org:open -u PkgOrg

sfdx force:user:password:generate --targetusername forms

sfdx force:user:display --targetusername forms

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
