## Dev, Build and Test

sfdx force:auth:web:login --setdefaultdevhubusername --setalias clarity-digital-devhub

sfdx force:org:list --all

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias cf-scratch-org --durationdays 30

sfdx force:alias:set cf-scratch-org=test-7n0glslr7plg@example.com

sfdx force:config:set defaultusername=cf-scratch-org

sfdx force:source:push -f

sfdx force:org:open -u cf-scratch-org

sfdx force:user:password:generate --targetusername cf-scratch-org

sfdx force:user:display --targetusername cf-scratch-org

## Assign persmission set

sfdx force:user:permset:assign -n Clarity_Forms_Builder -u cf-scratch-org

## Delete scratch org

sfdx force:org:delete -u test-7n0glslr7plg@example.com

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

## Useful commands

sfdx force:data:tree:export -q "SELECT Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, Phone, Website FROM Account WHERE BillingStreet != NULL AND BillingCity != NULL and BillingState != NULL" -d ./data

sfdx force:data:tree:import --sobjecttreefiles data/Account.json
