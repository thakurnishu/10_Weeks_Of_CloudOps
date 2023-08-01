#!/bin/bash

# VM name
app="App-tier"
web="Web-tier"
jump="BastionHost"

# Resource Variable
resourceGroup="10_Weeks_Of_CloudOps"
location="eastus"

echo "-----------------------------------------------------"
echo "|        Deleting Web-VM, Web-Disk, Web-NIC        |"
echo "-----------------------------------------------------"

webDisk=$(az vm show --resource-group $resourceGroup --name $web-VM --query 'storageProfile.osDisk.name' -o tsv)
webNIC=$(az vm show --resource-group $resourceGroup --name $web-VM --query 'networkProfile.networkInterfaces[0].id' -o tsv | awk -F'/' '{print $NF}')

az vm delete -g $resourceGroup -n $web-VM --yes
az network nic delete -g $resourceGroup -n "$webNIC" --yes
az disk delete -g $resourceGroup -n "$webDisk" --yes
echo "Web VM is deleted."
echo

echo "-----------------------------------------------------"
echo "|        Deleting App-VM, App-Disk, App-NIC        |"
echo "-----------------------------------------------------"

appDisk=$(az vm show --resource-group $resourceGroup --name $app-VM --query 'storageProfile.osDisk.name' -o tsv)
appNIC=$(az vm show --resource-group $resourceGroup --name $app-VM --query 'networkProfile.networkInterfaces[0].id' -o tsv | awk -F'/' '{print $NF}')

az vm delete -g $resourceGroup -n $app-VM --yes
az network nic delete -g $resourceGroup -n "$appNIC" --yes
az disk delete -g $resourceGroup -n "$appDisk" --yes
echo "App VM is deleted"
echo 

echo "-----------------------------------------------------"
echo "|        Deleting Web-VM, Web-Disk, Web-NIC        |"
echo "-----------------------------------------------------"

jumpDisk=$(az vm show --resource-group $resourceGroup --name $jump-VM --query 'storageProfile.osDisk.name' -o tsv)
jumpNIC=$(az vm show --resource-group $resourceGroup --name $jump-VM --query 'networkProfile.networkInterfaces[0].id' -o tsv | awk -F'/' '{print $NF}')

az vm delete -g $resourceGroup -n $jump-VM --yes
az network nic delete -g $resourceGroup -n $jumpNIC --yes
az disk delete -g $resourceGroup -n "$jumpDisk" --yes
az network public-ip delete -g $resourceGroup -n $jump-VMPublicIP --yes
echo "Bastion VM is deleted"
echo 
