Installing the database:

Please run the following database scripts under the directory "/MixERP.Net.FrontEnd/db/en-US/", in this order:

1. mixerp.sql
2. customer-sample.sql
3. sample-data.sql


Non English Speaking Countries:

MixERP is a multilingual product by design. Instead of hardcoding everying, we maintain a central resource file respository on the directory "MixERP.Net.FrontEnd/App_GlobalResources".

Please find the following files:

Titles.resx
-Titles and only titles should be stored in this file, complying to the rules of capitalization. Resource keys: use ProperCasing.

Questions.resx
-Questions are stored in this file. Resource keys: ProperCasing.

Labels.resx
-Field labels are stored here. Must be a complete sentence or meaningful phrase. Resource key: use ProperCasing.

Warnings.resx
-Application warnings are stored here. Must be a complete sentence or meaningful phrase. Resource key: use ProperCasing.

Setup.resx
-System resource. Resource key: use ProperCasing.


FormResource.resx
-PostgreSQL columns are stored as resource keys. These are used on dynamically generated forms and reports. Resource key: use lowercase_underscore_separator.


More still to come under this line ...
