#!/bin/bash 
#this script is used for downloading openstack-havana rpms
#date: 2014-7-8

prepare_repo=0
download_packages=0
download_already=0 
last_rpms_num=0 

> file.last
> file.now
> download.log  

date >> download.log
echo "start downloading openstack rpm packages..." >> download.log

while [ $download_already -eq 0 ] 
do 

    #get distribution release
    if [ $prepare_repo -eq 0 ] 
    then
		yumdownloader yum-plugin-priorities  --resolve
        yumdownloader http://repos.fedorapeople.org/repos/openstack/openstack-icehouse/rdo-release-icehouse-3.noarch.rpm --resolve 
        yumdownloader http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm --resolve 
        yum install -y http://repos.fedorapeople.org/repos/openstack/openstack-icehouse/rdo-release-icehouse-3.noarch.rpm
        yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm 
        yum install -y yum-plugin-priorities
        prepare_repo=1
    fi
    echo "finish preparing for initiating openstack RDO repository ..." >> download.log 
  

    #download openstack rpms, you add others in the following list
    if [ $download_packages -eq 0 ]
    then
        #rabbit mq
        yumdownloader openstack-utils --resolve
        yumdownloader openstack-selinux --resolve
        yumdownloader mysql --resolve
        yumdownloader MySQL-python --resolve
        yumdownloader mysql-server --resolve
        yumdownloader ntp --resolve
        yumdownloader openstack-keystone --resolve
        yumdownloader python-keystoneclient --resolve
        yumdownloader openstack-glance --resolve
        yumdownloader python-glanceclient --resolve
		yumdownloader openstack-nova-api --resolve
		yumdownloader openstack-nova-cert --resolve
		yumdownloader openstack-nova-conductor --resolve
		yumdownloader openstack-nova-console --resolve
		yumdownloader openstack-nova-novncproxy --resolve
		yumdownloader openstack-nova-scheduler --resolve
		yumdownloader openstack-nova-compute --resolve
		yumdownloader openstack-nova-network --resolve
        yumdownloader openstack-nova --resolve
        yumdownloader python-novaclient --resolve
		yumdownloader memcached --resolve
        yumdownloader python-memcached --resolve
        yumdownloader mod_wsgi --resolve
        yumdownloader openstack-dashboard --resolve
        yumdownloader openstack-cinder --resolve
        yumdownloader python-cinderclient --resolve
		yumdownloader scsi-target-utils --resolve
        yumdownloader openstack-swift --resolve
        yumdownloader openstack-swift-proxy --resolve
        yumdownloader openstack-swift-account --resolve
        yumdownloader openstack-swift-container --resolve
        yumdownloader openstack-swift-object --resolve
        yumdownloader xfsprogs --resolve
        yumdownloader python-keystone-auth-token --resolve
        yumdownloader openstack-neutron --resolve
		yumdownloader openstack-neutron-ml2 --resolve
        yumdownloader python-neutronclient --resolve
        yumdownloader openstack-neutron-openvswitch --resolve
        yumdownloader python-neutron --resolve
        yumdownloader openstack-heat-api --resolve
        yumdownloader openstack-heat-engine --resolve
        yumdownloader openstack-heat-api-cfn --resolve
        yumdownloader openstack-heat-api-cloudwatch --resolve
        yumdownloader python-heatclient --resolve
        yumdownloader openstack-ceilometer-api --resolve
        yumdownloader openstack-ceilometer-collector --resolve
        yumdownloader openstack-ceilometer-central --resolve
		yumdownloader openstack-ceilometer-notification --resolve
		yumdownloader openstack-ceilometer-alarm --resolve
		yumdownloader openstack-ceilometer-compute --resolve
        yumdownloader python-ceilometerclient --resolve
		yumdownloader python-pecan --resolve
        yumdownloader mongodb-server --resolve
        yumdownloader mongodb --resolve
        yumdownloader openstack-trove --resolve
		yumdownloader python-troveclient --resolve
        yumdownloader rabbitmq-server --resolve
		yumdownloader qpid-cpp-server --resolve

        download_packages=1
    fi
    echo "download openstack packages already... ^_^" >> download.log


    #download recursive dependency rpms
    rpms_num=`ls |grep .rpm | awk -F '-[0-9]' '{print $1}'|wc -l`
    ls |grep .rpm | awk -F '-[0-9]' '{print $1}' > file.now

    if [ $rpms_num -gt $last_rpms_num ]
    then
        rpms=`diff file.now file.last |grep '<' |awk -F ' ' '{print $2}'|awk -F '-[0-9]' '{print $1}'`
       
        rm -rf file.last
        mv file.now file.last
        last_rpms_num=$rpms_num
       
        for rpm in $rpms
        do
            yumdownloader $rpm --resolve
            echo "download  $rpm" >>download.log
        done
    else
        download_already=1
    fi

done

date >> download.log
echo "finish downloading ^_^" >> download.log
rm -rf file.now file.last
