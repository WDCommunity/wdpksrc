#!/bin/bash

export DOCKER_RAMDISK=1

DOCKER=/sbin/docker
DOCKERD=/sbin/dockerd

docker_root=/shares/Volume_1/Nas_Prog/_docker

function is_mountpoint
{
    mnts=$(cat /proc/self/mounts | grep "$1" | awk '{print $2}')

    for i in "${mnts[@]}"
    do
        if [ "$i" == "$1" ] ; then
            return 0
        fi
    done

    return 1
}

function is_docker_setup
{
    btrfs_mounted=$(cat /proc/mounts | grep var/lib/docker)
    if [ -z "${btrfs_mounted}" ]; then
        echo 'Docker setup NOK'
        return 1
    else 
        echo 'Docker setup OK'
    fi
}

function docker_setup
{
    is_docker_setup && return 0

    echo "Setting up docker"

    # replace old symlink by actual dir
    if [ -L /var/lib/docker ]; then
       echo 'Found docker symlink'
    #  rm -f /var/lib/docker
    else
       echo 'No symlink found'
       ln -sf ${docker_root} /var/lib/docker 
    fi
    #mkdir -p /var/lib/docker
    

    # For iptables
    ln -s /usr/local/modules/usrlib/xtables /usr/lib/xtables
    #ln -s /usr/local/modules/usrlib/* /usr/lib/.
    #ln -s /usr/local/modules/usrbin/* /usr/bin/.

    if [ ! -L /usr/sbin/mkfs.ext4 ]; then
      ln -s /usr/bin/mke2fs /usr/sbin/mkfs.ext4
    fi

    if ! `lsmod | grep ^ipv6 &> /dev/null`; then
      echo "Loading ipv6"
      insmod /usr/local/modules/driver/ipv6.ko disable_ipv6=1
    fi

    echo "Loading drivers"

    drivers=(
    "/usr/local/modules/driver/nf_conntrack.ko"
    "/usr/local/modules/driver/nf_nat.ko"
    "/usr/local/modules/driver/nf_defrag_ipv4.ko"
    "/usr/local/modules/driver/nf_conntrack_ipv4.ko"
    "/usr/local/modules/driver/nf_nat_ipv4.ko"
    # "/usr/local/modules/driver/nf_defrag_ipv6.ko"
    # "/usr/local/modules/driver/nf_conntrack_ipv6.ko"
    "/usr/local/modules/driver/x_tables.ko"
    "/usr/local/modules/driver/xt_conntrack.ko"
    "/usr/local/modules/driver/xt_addrtype.ko"
    #"/usr/local/modules/driver/xt_mark.ko"
    #"/usr/local/modules/driver/xt_policy.ko"
    "/usr/local/modules/driver/xt_tcpudp.ko"
    "/usr/local/modules/driver/xt_nat.ko"
    "/usr/local/modules/driver/nf_nat_masquerade_ipv4.ko"
    "/usr/local/modules/driver/ipt_MASQUERADE.ko"
    #"/usr/local/modules/driver/ipt_REJECT.ko"
    #"/usr/local/modules/driver/ipt_ULOG.ko"
    #"/usr/local/modules/driver/ip6_tables.ko"
    #"/usr/local/modules/driver/ip6t_REJECT.ko"
    #"/usr/local/modules/driver/ip6t_ipv6header.ko"
    #"/usr/local/modules/driver/ip6table_filter.ko"
    #"/usr/local/modules/driver/ip6table_mangle.ko"
    "/usr/local/modules/driver/ip_tables.ko"
    "/usr/local/modules/driver/iptable_filter.ko"
    #"/usr/local/modules/driver/iptable_mangle.ko"
    "/usr/local/modules/driver/iptable_nat.ko"
    "/usr/local/modules/driver/llc.ko"
    "/usr/local/modules/driver/stp.ko"
    "/usr/local/modules/driver/bridge.ko"
    "/usr/local/modules/driver/br_netfilter.ko"
    )

    for m in "${drivers[@]}"; do
      echo "Loading $m"
      if ! insmod $m ; then
        echo failed to load $m
      fi
      #sleep 1
    done

    echo "Setting up cgroup"
    umount /sys/fs/cgroup 2>/dev/null
    /usr/sbin/cgroupfs-mount

    # On Yosemite /dev/pts is not mounted; required for docker container tty
    if [ ! -d /dev/pts ]; then
        mkdir /dev/pts
        mount -t devpts devpts /dev/pts
    fi
}

function docker_stop
{
    # Stop all containers
    containers="$(${DOCKER} ps -q)"
    if [ ! -z "${containers}" ]; then
        echo "Stopping containers ${containers}"
        ${DOCKER} stop ${containers}
    fi

    # Stop docker
    docker_pid="$(cat /var/run/docker.pid)"
    if [ ! -z "${docker_pid}" ]; then
        echo "Stopping Docker pid=${docker_pid}"
        kill "${docker_pid}"
    fi
}


function dm_cleanup
{
    shm_mounts=$(cat /proc/self/mounts | grep "shm.*docker" | awk '{print $2}')
    
    for mnt in "${shm_mounts[@]}";
    do  
        echo "shm_cleanup: ${mnt}"
        umount "$mnt"
    done 
    
    if [ ! -z $(cat /proc/self/mounts | grep -c docker) ]; then
        umount /var/lib/docker/plugins
        umount /var/lib/docker
    fi
    
    dmsetup remove_all
}

function docker_cleanup
{
    echo "Cleaning up Docker"

    # remove cgroup stuff
    /usr/sbin/cgroupfs-umount

    dm_cleanup
}

function set_docker_cgroup
{
    ONE_G_KB=1048576

    mem_quota=0
    mem_total_kb=`grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}'`

    if [[ ! "${mem_total_kb}" =~ ^[0-9]+$ ]] ; then
        echo "Failed to get total memory!"
        return 1
    fi

    if [ ${mem_total_kb} -gt ${ONE_G_KB} ]; then
        mem_quota=$((mem_total_kb/2))
    else
        mem_quota=$((mem_total_kb/3))
    fi

    echo "Total RAM: ${mem_total_kb} KB"

    if is_mountpoint /sys/fs/cgroup/memory; then
        echo "Creating /sys/fs/cgroup/memory/docker"
        mkdir -p /sys/fs/cgroup/memory/docker
    else
        echo "/sys/fs/cgroup/memory is not a cgroup mount"
        return 1
    fi

    echo "Docker quota: ${mem_quota} KB"
    if echo "${mem_quota}K" > /sys/fs/cgroup/memory/docker/memory.limit_in_bytes ; then
        # Docker and all containers use the same memory limit
        echo 1 > /sys/fs/cgroup/memory/docker/memory.use_hierarchy
        echo -n "Set memory quota for docker: "
        cat /sys/fs/cgroup/memory/docker/memory.limit_in_bytes
    fi
}

case $1 in
    start)
        echo "Starting Docker"
        is_docker_setup || (echo "Docker is not setup! Run docker_daemon.sh setup" && exit 1)
        dm_cleanup
        cgroupfs-mount
        set_docker_cgroup
        ${DOCKERD} -D >> /var/lib/docker/docker.log 2>&1 &
        docker_pid=$!
        # Attach docker pid to memory cgroup
        if [[ "${docker_pid}" =~ ^[0-9]+$ ]]; then
            echo ${docker_pid} > /sys/fs/cgroup/memory/docker/tasks
        fi
        echo "Docker pid ${docker_pid}"
        ;;
    stop)
        docker_stop
        ;;
    status)
        docker_pid=$(pidof dockerd)
        docker_mounts=$(cat /proc/self/mounts | grep docker)
        if [ -z "${docker_pid}" ]; then
            echo "Docker is not running!"
            if [ "${docker_mounts}"]; then
                echo "Found mounts: ${docker_mounts}"
            fi
            exit 1
        fi
        ;;
    setup)
        docker_setup
        ;;
    issetup)
        if ! is_docker_setup ; then
           exit 1
        fi   
        ;;
    shutdown)
        docker_stop
        docker_cleanup
        ;;
    *)
        echo "Invalid command!"
        exit 1
        ;;
esac

