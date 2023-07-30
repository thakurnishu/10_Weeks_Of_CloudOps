#!/bin/bash

# Resource Variable
resourceGroup="10_Weeks_Of_CloudOps"
location="eastus"
Vnet="Week-2-Vnet"

# VM name
app="App-tier"
web="Web-tier"
jump="Jump"

# User Credentials
adminUser="week2"
adminPwd="Challenge@week2"


echo "-----------------------------------------"
echo "|        Creating Resource Group        |"
echo "-----------------------------------------"
az group create --name $resourceGroup \
  --location $location \
  > /dev/null
echo "Resource Group is Created."
echo && echo 

echo "-----------------------------------------"
echo "|  Creating Virtual Network and Subnet  |"
echo "-----------------------------------------"
az network vnet create --resource-group $resourceGroup \
  --name $Vnet \
  --address-prefix 10.0.0.0/16 \
  --location $location \
  > /dev/null
echo "Virtual Network is Created."
echo 

# Jump-Subnet
az network vnet subnet create --resource-group $resourceGroup \
  --vnet-name $Vnet \
  --name $jump-Subnet \
  --address-prefix 10.0.1.0/24 \
  --no-wait

# Web-tier-Subnet
az network vnet subnet create --resource-group $resourceGroup \
  --vnet-name $Vnet \
  --name $web-Subnet \
  --address-prefix 10.0.2.0/24 \
  --no-wait

# App-tier-Subnet
az network vnet subnet create --resource-group $resourceGroup \
  --vnet-name $Vnet \
  --name $app-Subnet \
  --address-prefix 10.0.3.0/24 \
  --no-wait

# PrivateEndpoint-Subnet
az network vnet subnet create --resource-group $resourceGroup \
  --vnet-name $Vnet \
  --name PrivateEndpoint-Subnet \
  --address-prefix 10.0.4.0/27 \
  --no-wait

# ApplicationGateway-Subnet
az network vnet subnet create --resource-group $resourceGroup \
  --vnet-name $Vnet \
  --name ApplicationGateway-Subnet \
  --address-prefix 10.0.5.0/24 \
  > /dev/null
echo "Subnets are created and Attached to Vnet."
echo && echo 


echo "-------------------------------------------------"
echo "|  Creating Network Security Group for Subnets  |"
echo "-------------------------------------------------"
# Jump-nsg
az network nsg create --resource-group $resourceGroup \
    --name $jump-nsg \
    --location $location \
    --no-wait

# Web-nsg
az network nsg create --resource-group $resourceGroup \
    --name $web-nsg \
    --location $location \
    --no-wait

# App-nsg
az network nsg create --resource-group $resourceGroup \
    --name $app-nsg \
    --location $location \
    --no-wait

# PrivateEndpoint-nsg
az network nsg create --resource-group $resourceGroup \
    --name PrivateEndpoint-nsg \
    --location $location \
    --no-wait

# ApplicationGateaway-nsg
az network nsg create --resource-group $resourceGroup \
    --name ApplicationGateaway-nsg \
    --location $location \
    > /dev/null
echo "NSG are Created."
echo && echo 


echo "-----------------------------------"
echo "|  Rules for Each Security Group  |"
echo "-----------------------------------"
# Jump-nsg-rule
az network nsg rule create --resource-group $resourceGroup \
    --nsg-name $jump-nsg \
    --name "AllowSSH" \
    --priority 1010 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 22 \
    --no-wait

# Web-nsg-rules
az network nsg rule create --resource-group $resourceGroup \
    --nsg-name $web-nsg \
    --name "AllowSSH" \
    --priority 1010 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 22 \
    --no-wait

az network nsg rule create --resource-group $resourceGroup \
    --nsg-name $web-nsg \
    --name "AllowHTTP" \
    --priority 100 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 80 \
    --no-wait

# App-nsg-rules
az network nsg rule create --resource-group $resourceGroup \
    --nsg-name $app-nsg \
    --name "AllowSSH" \
    --priority 1010 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 22 \
    --no-wait

az network nsg rule create --resource-group $resourceGroup \
    --nsg-name $app-nsg \
    --name "Allow4000" \
    --priority 100 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 4000 \
    --no-wait

az network nsg rule create --resource-group $resourceGroup \
    --nsg-name $app-nsg \
    --name "AllowSQL" \
    --priority 110 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 3306 \
    --no-wait

# PrivateEndpoint-nsg-rule
az network nsg rule create --resource-group $resourceGroup \
    --nsg-name PrivateEndpoint-nsg \
    --name "AllowSQL" \
    --priority 1010 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 3306 \
    --no-wait

# ApplicationGateaway-nsg-rule
az network nsg rule create --resource-group $resourceGroup \
    --nsg-name ApplicationGateaway-nsg \
    --name "AllowHTTP" \
    --priority 1010 \
    --protocol "Tcp" \
    --direction "Inbound" \
    --source-address-prefixes "*" \
    --source-port-ranges "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges 80 \
    > /dev/null
echo "NSG Rules are Created."
echo && echo 


echo "---------------------------------------------"
echo "|  Creating Temporary Vm for Image Creation |"
echo "---------------------------------------------"
# Jump-VM
az vm create --resource-group $resourceGroup \
  --name $jump-VM \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username $adminUser \
  --admin-password $adminPwd \
  --vnet-name $Vnet \
  --subnet $jump-Subnet \
  --no-wait

# Web-tier-VM
az vm create --resource-group $resourceGroup \
  --name $web-VM \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username $adminUser \
  --admin-password $adminPwd \
  --vnet-name $Vnet \
  --subnet $web-Subnet \
  --public-ip-address "" \
  --no-wait

# App-tier-VM
az vm create --resource-group $resourceGroup \
  --name $app-VM \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username $adminUser \
  --admin-password $adminPwd \
  --vnet-name $Vnet \
  --subnet $web-Subnet \
  --public-ip-address "" \
  > /dev/null
echo "VMs are Created"
echo && echo


echo "-------------------------------------------------"
echo "| Creating LoadBalancer and Application Gateway |"
echo "-------------------------------------------------"



