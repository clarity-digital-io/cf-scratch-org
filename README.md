# SFDX  App

## Dev, Build and Test
sfdx force:org:list

sfdx force:org:create --definitionfile config/project-scratch-def.json --setdefaultusername --setalias clarity-scratch-org

sfdx force:alias:set YourAlias=username@example.com

sfdx force:user:password:generate --targetusername test-cvhixsrduu8h@example.com

sfdx force:user:display --targetusername test-cvhixsrduu8h@example.com

sfdx force:config:set defaultusername=test-cvhixsrduu8h@example.com

sfdx force:source:push

## Resources


## Description of Files and Directories


## Issues


## clarity-survey-salesforce-mp
