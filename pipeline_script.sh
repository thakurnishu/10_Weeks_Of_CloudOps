#!/bin/bash

AccountName="firstweekofcloudops"
RG="10_Weeks_Of_CloudOps"
ProfileName="CDN-First-Week"
EndPoint="firstweekendpoint"

echo "--------------------------------------------------------"
echo "|   Removing previous content from CDN edge locations  |"
echo "--------------------------------------------------------"

az cdn endpoint purge \
      --name $EndPoint \
      --profile-name $ProfileName \
      --resource-group $RG \
      --content-paths "/*"


echo "--------------------------------------------------------"
echo "|           Uploading to Azure Storage Account         |"
echo "--------------------------------------------------------"

Connection_String=$(az storage account show-connection-string --name $AccountName --resource-group $RG --query connectionString -o tsv)
az storage blob upload-batch \
  -d "\$web" \
  -s "website" \
  --connection-string $Connection_String \
  --overwrite \
  --pattern "*"
