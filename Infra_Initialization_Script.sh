#!/bin/bash

RG="10_Weeks_Of_CloudOps"
Location="eastus"
AccountName="firstweekofcloudops"
ProfileName="CDN-First-Week"
EndPoint="firstweekendpoint"

echo "-------------------------------------"
echo "|      Creating Resource Group      |"
echo "-------------------------------------"
az group create \
  --name $RG \
  --location $Location


echo "-------------------------------------"
echo "|  Creating Azure Storage Account   |"
echo "-------------------------------------"
az storage account create \
  --name $AccountName \
  --resource-group $RG \
  --location $Location \
  --sku Standard_LRS \
  --kind StorageV2


echo "-------------------------------------"
echo "|      Enabling Static-Website      |"
echo "-------------------------------------"
az storage blob service-properties update \
  --account-name $AccountName \
  --static-website \
  --index-document "index.html" \
  --404-document "error.html"


echo "-------------------------------------"
echo "|        Creating CDN Profile       |"
echo "-------------------------------------"
az cdn profile create \
  --name $ProfileName \
  --resource-group $RG \
  --sku Standard_Microsoft


echo "-------------------------------------"
echo "|     Uploading Website Files       |"
echo "-------------------------------------"
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


echo "-------------------------------------"
echo "|     Creating CDN End Point        |"
echo "-------------------------------------"
sleep 10

url=$(az storage account show --name $AccountName --resource-group $RG --query "primaryEndpoints.web" -o tsv | sed 's/^https:\/\/\([^/]*\)\/$/\1/')
az cdn endpoint create \
  --name $EndPoint \
  --profile-name $ProfileName \
  --resource-group $RG \
  --origin $url \


echo "------------------------------------------------------------------------------------------------------------------------------------------------"
echo "|     Wait for CDN to Configure Only few Mintues :) Your Setup is Almost Ready Here is Your CDN EndPoint https://$EndPoint.azureedge.net       |"
echo "------------------------------------------------------------------------------------------------------------------------------------------------"

