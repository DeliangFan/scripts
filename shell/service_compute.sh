#!/bin/bash
# --------------------------------------------------------------------------------
# Filename: service_compute.sh
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
 
function nova_start()
{
    service openstack-nova-compute start
}
 
function nova_stop()
{
    service openstack-nova-compute stop
}
 
function nova_restart()
{
    service openstack-nova-compute restart
}
function neutron_start()
{
    service openstack-neutron-openvswitch-agent start
}
 
function neutron_stop()
{
    service openstack-neutron-openvswitch-agent stop
}
 
function neutron_restart()
{
    service openstack-neutron-openvswitch-agent restart
}
 
function ceilometer_start()
{
    service openstack-ceilometer-agent-compute start
}
 
function ceilometer_stop()
{
    service openstack-ceilometer-agent-compute stop
}
 
function ceilometer_restart()
{
    service openstack-ceilometer-agent-compute restart
}
 
function openstack_start()
{
    nova_start
    neutron_start
    ceilometer_start
}
 
function openstack_stop()
{
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
