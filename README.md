## Dev, Build and Test

sfdx force:auth:web:login --setdefaultdevhubusername --setalias clarity-digital-devhub

sfdx force:org:list --all

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias mobile-prod --durationdays 30

sfdx force:alias:set mobile-prod=test-zeztiknzccq6@example.com

sfdx force:config:set defaultusername=mobile-prod

sfdx force:source:push -f

sfdx force:org:open -u mobile-prod

sfdx force:user:password:generate --targetusername mobile-prod

sfdx force:user:display --targetusername mobile-prod

## Delete scratch org

sfdx force:org:delete -u test-vkriuxsmyqff@example.com

## Use Cases

Digital Signatures Approval Process
Add filtering on the Lookups by Record Type and other fields
Add RecordType select on Record Group
Timeline
ResponsesTable
FormResponse - (New, Edit, Submitted, Locked)

## Other notes for development

- querying from org

https://salesforce.stackexchange.com/questions/358014/error-we-cant-query-your-org-getting-this-error-after-authorize-a-dev-hub
