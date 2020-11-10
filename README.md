## Dev, Build and Test
sfdx force:auth:web:login --setdefaultdevhubusername --setalias clarity-force-devhub

sfdx force:org:list --all

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias mobile-prod --durationdays 30 //clarity-forms-pkg

sfdx force:alias:set mobile-prod=test-i1zoep09dswc@example.com

sfdx force:config:set defaultusername=mobile-prod

sfdx force:source:push -f

sfdx force:org:open -u PkgOrg

sfdx force:user:password:generate --targetusername mobile-prod

sfdx force:user:display --targetusername mobile-prod

## Use Cases

Digital Signatures Approval Process
Add filtering on the Lookups by Record Type and other fields
Add RecordType select on Record Group
Timeline
ResponsesTable
FormResponse - (New, Edit, Submitted, Locked)