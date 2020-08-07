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

## Delete Packages

sfdx force:mdapi:deploy -d destructiveChanges -u PkgOrg -l NoTestRun -w 15

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

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias mobile-test-prod-two --durationdays 60 //clarity-forms-pkg

sfdx force:alias:set mobile-test-prod-two=test-lanivcw2dtmk@example.com

sfdx force:config:set defaultusername=mobile-test-prod-two

sfdx force:source:push -f

sfdx force:org:open -u PkgOrg

sfdx force:user:password:generate --targetusername mobile-test-prod-two

sfdx force:user:display --targetusername mobile-test-prod-two

sfdx force:org:delete -u test-lanivcw2dtmk@example.com

## Mobile Settings Controller Should:

- get company information (sandbox + company)
- check user permission (clarity forms mobile)
- get user info 

## Tests

sfdx force:lightning:component:create -n WizardMobileSetup -d force-app/main/default/aura --type aura

sfdx force:apex:class:create -n SetupController -d force-app/main/default/classes/controllers

## Security Checks 

sfdx force:lightning:component:create --type lwc -d force-app/main/default/lwc/ -n responseReview
sfdx force:lightning:component:create --type lwc -d force-app/main/default/lwc/ -n responseReviewAnswer

sfdx force:apex:class:create -n FormSummaryControllerUnitTest -d force-app/main/default/classes/tests/controllers

sfdx force:apex:class:create -n BuilderControllerUnitTest -d force-app/main/default/classes/tests/controllers

sfdx force:apex:class:create -n ConnectionJob -d force-app/main/default/classes/batchjobs

sfdx force:apex:class:create -n FormConnectionProcessSelector -d force-app/main/default/classes/selectors

sfdx force:apex:class:create -n IFormConnectionProcessSelector -d force-app/main/default/classes/selectors

sfdx force:apex:class:create -n SetupControllerUnitTest -d force-app/main/default/classes/selectors

sfdx force:apex:class:create -n ResponsesUnitofWorkHelper -d force-app/main/default/classes/domains/helpers

## Resources

sfdx force:data:soql:query -q "Select Id, MemberName From SourceMember Where MemberType = 'ConnectedApp'" -t
sfdx force:data:record:delete -s SourceMember -i0MZ5400000E2q3SGAR -t

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

## UI for Mobile Users setUsers mobileUserSync

# Columns
- User Name
- Has Permission Set 
- Switch 
