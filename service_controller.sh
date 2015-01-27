#!/bin/bash
 
# --------------------------------------------------------------------------------
# Filename: service_controller.sh
# Date:     2014/11/3
# Author:   Deliang Fan
# Discription:  This script is used for managing the openstack's services. Most of
#               the time, we want to lanuch or check nova project or all openstack
#               service, now you can use this script to complete the target!
#---------------------------------------------------------------------------------
 
function usages()
{
    echo "This script is used for managing the openstack's services. Most of the time,"
    echo "we want to lanuch or check nova project or openstack service, now you can use"
    echo "this script to complete the target!"
    echo ""
    echo "Usage: ./service_controller.sh component action"
    echo "    component [openstack|nova|glance|neutron|ceilometer]"
    echo "    action [start|stop|restart]"
    echo ""
    echo "Example:"
    echo "    ./service_controller.sh openstack start # this will try to start all services"
    echo "    ./service_controller.sh nova start      # this will try to start all nova services"
    echo ""
    exit 0 
}
 
function glance_start()
{
    service openstack-glance-api start
    service openstack-glance-registry start
}
 
function glance_stop()
{
    service openstack-glance-api stop
    service openstack-glance-registry stop
}
 
function glance_restart()
{
    glance_stop
    glance_start
}
 
function nova_start()
{
    service openstack-nova-api start
    service openstack-nova-scheduler start
    service openstack-nova-conductor start
    service openstack-nova-novncproxy start
    service openstack-nova-consoleauth start
}
 
function nova_stop()
{
    service openstack-nova-api stop
    service openstack-nova-scheduler stop
    service openstack-nova-conductor stop
    service openstack-nova-novncproxy stop
    service openstack-nova-consoleauth stop
}
 
function nova_restart()
{
    nova_stop
    nova_start
}
 
function neutron_start()
{
    service neutron-server start
}
 
function neutron_stop()
{
    service neutron-server stop
}
 
function neutron_restart()
{
    service neutron-server restart
}
 
function ceilometer_start()
{
    service openstack-ceilometer-api start
    service openstack-ceilometer-collector start
    service openstack-ceilometer-agent-notification start
}
 
function ceilometer_stop()
{
    service openstack-ceilometer-api stop
    service openstack-ceilometer-collector stop
    service openstack-ceilometer-agent-notification stop
}
 
function ceilometer_restart()
{
    ceilometer_start
    ceilometer_stop
}
 
function openstack_start()
{
    glance_start
    nova_start
    neutron_start
    ceilometer_start
}
 
function openstack_stop()
{
    glance_stop
    nova_stop
    neutron_stop
    ceilometer_stop
}
 
function openstack_restart()
{
    openstack_stop
    openstack_start
}
 
component=$1
action=$2
 
case $component in
    -h|--help | "") usages;;
esac
 
case $action in
    start)
    ${component}_start
    ;;
    stop)
    ${component}_stop
    ;;
    restart)
    ${component}_restart
    ;;
esac
 
exit 0
