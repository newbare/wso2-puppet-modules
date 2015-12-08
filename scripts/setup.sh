#!/bin/bash
echo "#####################################################"
echo "                   Starting cleanup "
echo "#####################################################"
ps aux | grep -i wso2 | awk {'print $2'} | xargs kill -9
rm -rf /mnt/*
sed -i '/certname/d' /etc/puppet/puppet.conf
#sed -i '/server = puppet/a environment=production' /etc/puppet/puppet.conf
sed -i '/environment/d' /etc/puppet/puppet.conf
echo "#####################################################"
echo "               Setting up environment "
echo "#####################################################"
rm -f /etc/facter/facts.d/deployment_pattern.txt
#rm /etc/facter/facts.d/deployment_pattern.txt
mkdir -p /etc/facter/facts.d

#deployment_pattern=$(<deployment.conf)

while read -r line; do declare  $line; done < deployment.conf
echo "#####################################################"
echo -e "   puppet environment set to \x09-> $puppet_environment "
echo -e "   deployment set to \x09\x09-> $deployment "
echo -e "   deployment pattern set to \x09-> $deployment_pattern "
echo "#####################################################"

echo puppet_environment=$puppet_environment >> /etc/facter/facts.d/deployment_pattern.txt
echo deployment=$deployment >> /etc/facter/facts.d/deployment_pattern.txt
echo deployment_pattern=$deployment_pattern >> /etc/facter/facts.d/deployment_pattern.txt

echo "#####################################################"
echo "                    Installing "
echo "#####################################################"

for (( i=1; i <= 2; i++ ))
do
 puppet agent --enable
 puppet agent -vt
 puppet agent --disable
done

