#!/bin/bash

RG="10_Weeks_Of_CloudOps"
Location="centralindia"
AccountName="myfirstweekofcloudops"
ProfileName="CDN-First-Week"

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

echo "--------------------------------------------------------------------------------"
echo "| Upload Website Content and Create CDN Endpoint with above create CDN Profile |"
echo "-------------------------------------------------------------------------------"
