First check wheather your VM have nested virtualization enabled.

grep -cw vmx /proc/cpuinfo
=> it must return non-zero value


sudo apt-get update
sudo apt-get install --assume-yes qemu-kvm libvirt-daemon libvirt-daemon-system dnsmasq

sudo usermod -a -G libvirt $(whoami)
sudo usermod -a -G libvirt-qemu $(whoami)
sudo usermod -a -G libvirt-dnsmasq $(whoami)

sudo reboot

cat << EOF | sudo tee /etc/systemd/resolved.conf > /dev/null  
[Resolve]
DNS=127.0.0.2
Domains=apps-crc.testing crc.testing
EOF 

sudo sed -i 's/#listen-address=/listen-address=127.0.0.2/g' /etc/dnsmasq.conf 

cat << EOF | sudo tee /etc/default/dnsmasq > /dev/null  
DOMAIN_SUFFIX=``
ENABLED=1
CONFIG_DIR=/etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new
IGNORE_RESOLVCONF=yes
EOF

cat << EOF | sudo tee /etc/dnsmasq.d/crc.conf > /dev/null  
address=/crc.testing/192.168.130.11
address=/apps-crc.testing/192.168.130.11
server=/#/8.8.8.8
EOF

sudo systemctl restart systemd-resolved
sudo systemctl restart dnsmasq

dig foo.apps-crc.testing | echo $(grep 192.168.130.11)
dig api.crc.testing | echo $(grep 192.168.130.11)


4.5.1

curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/crc/1.13.0/crc-linux-amd64.tar.xz && tar -Jxvf crc-linux-amd64.tar.xz && mkdir -p ~/bin && export PATH=$PATH:~/bin && mv crc-linux*/crc ~/bin/ && rm -rf crc*
#curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/crc/1.9.0/crc-linux-amd64.tar.xz && tar -Jxvf crc-linux-amd64.tar.xz && mkdir -p ~/bin && export PATH=$PATH:~/bin && mv crc-linux*/crc ~/bin/ && rm -rf crc*
#curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz && tar -Jxvf crc-linux-amd64.tar.xz && mkdir -p ~/bin && export PATH=$PATH:~/bin && mv crc-linux*/crc ~/bin/ && rm -rf crc*

crc config set skip-check-network-manager-installed true
crc config set skip-check-network-manager-config true
crc config set skip-check-network-manager-running true
crc config set skip-check-crc-dnsmasq-file true

#crc delete
#crc cleanup
#rm -rf ~/.crc
#crc config set network-mode user


crc setup
#crc daemon
# Download crc pull secret from https://cloud.redhat.com/openshift/install/crc/installer-provisioned and keep it in ~/.crc-pull-secret
#nohup crc start -m 20480 -p ~/crc-pull-secret.txt &
nohup crc start -p ~/crc-pull-secret.txt &

Download OC binary

https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz


References: 
===========
https://github.com/code-ready/crc/issues/549#issuecomment-529379181
https://github.com/code-ready/crc/issues/549#issuecomment-573676404
