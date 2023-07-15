#!/bin/bash

RG="10_Weeks_Of_CloudOps"
Location="centralindia"

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
  --name "myfirstweekofcloudops" \
  --resource-group $RG \
  --location $Location \
  --sku Standard_LRS \
  --kind StorageV2

