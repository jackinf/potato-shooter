#!/bin/bash

PROJECT_ID="rust-gamedev"
ZONE="europe-west4-a"
VM_NAME="potato-shooter-vm"

# Create the VM
gcloud compute instances create $VM_NAME \
  --project=$PROJECT_ID \
  --zone=$ZONE \
  --machine-type=e2-medium \
  --image-family=ubuntu-2004-lts \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=10GB
#  --metadata-from-file startup-script=startup.sh

# Wait for the VM to be ready
echo "Waiting for VM to boot up..."
sleep 30

# Open Firewall Ports
gcloud compute firewall-rules create potato-shooter-firewall \
  --project=$PROJECT_ID \
  --allow "tcp:80,udp:3536" \
  --target-tags=potato-shooter-server
gcloud compute instances add-tags $VM_NAME --tags=potato-shooter-server

# Fetch and display the external IP of the VM
EXTERNAL_IP=$(gcloud compute instances describe $VM_NAME --zone=$ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
echo "Matchbox server is running at ws://$EXTERNAL_IP:3536/extreme_bevy?next=2"
