gcloud compute disks create crc-disk --image-project ubuntu-os-cloud --image-family ubuntu-1804-lts --zone us-central1-a
gcloud compute images create crc-v4-image --source-disk crc-disk --source-disk-zone us-central1-a  --licenses "https://compute.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"

#use this image to create a vm instance 


for centos

gcloud compute images list

gcloud compute disks create crc-cent-disk --image-project centos-cloud --image-family centos-7 --zone us-central1-a
gcloud compute images create gcp-nested-vm-image --source-image=centos-7-v20210701 --source-image-project=centos-cloud --licenses="https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
