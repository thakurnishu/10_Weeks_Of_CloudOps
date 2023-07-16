#!/bin/bash

AccountName="firstweekofcloudops"
RG="10_Weeks_Of_CloudOps"

Connection_String=$(az storage account show-connection-string --name $AccountName --resource-group $RG --query connectionString -o tsv)
az storage blob upload-batch \
  -d "\$web" \
  -s "../10_Weeks_Of_CloudOps" \
  --connection-string $Connection_String \
  --overwrite \
  --pattern "*.html"

sleep 10

az storage blob upload-batch \
  -d "\$web" \
  -s "../10_Weeks_Of_CloudOps" \
  --connection-string $Connection_String \
  --overwrite \
  --pattern "*.jpeg"

