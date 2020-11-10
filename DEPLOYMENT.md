# Clarity Forms Salesforce App

## Creating a managed package

https://sfdx-isv.github.io/sfdx-workshop/

- Environment Hub
- Create new Partner Developer Org

## Packaging for Release

sfdx force:auth:web:login -a PkgOrg

sfdx force:org:create -a forms-pkg -s -f config/project-scratch-def.json

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

sfdx force:source:convert \
    -d mdapi-source/updated-package \
    -n "Clarity Forms"

sfdx force:mdapi:deploy \
    -d mdapi-source/updated-package \
    -u PkgOrg \
    -l NoTestRun \
    -w 15

sfdx force:package1:version:create \
    -i 0336g00000061bb \
    -n "Beta 2020" \
    -v "1.2" \
    -d "Managed mobile beta release." \
    -u PkgOrg \
    -w 15

sfdx force:package:version:promote --package "ClarityForms@1.2.0" -v clarity-force-devhub

sfdx force:org:open -u formsPkgTest

## Install Package in a Test Org

sfdx force:org:create -a formsPkgTest -n -f config/project-scratch-def.json

sfdx force:package1:version:list -u PkgOrg //get id

sfdx force:package:install \
    -p 04t6g000008OMW4AAO \
    -u formsPkgTest \
    -w 15

sfdx force:user:permset:assign -u formsPkgTest -n "Clarity_Forms_Builder"

## Delete Packages

sfdx force:mdapi:deploy -d destructiveChanges -u PkgOrg -l NoTestRun -w 15
