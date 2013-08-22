exec { "apt-get update":
    command => "/usr/bin/apt-get update",
    onlyif => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
}


Package { ensure => "installed" }

$packages = [ "conntrackd" ]
package { $packages: }


node /entry1/ {
  include keepalived

  keepalived::vrrp::instance { 'VI_50':
    interface         => 'eth1',
    state             => 'MASTER',
    virtual_router_id => '50',
    priority          => '101',
    virtual_ipaddress => [ '192.168.50.3/24' ],
  }

 keepalived::vrrp::instance { 'VI_55':
    interface         => 'eth2',
    state             => 'MASTER',
    virtual_router_id => '55',
    priority          => '101',
    virtual_ipaddress => [ '192.168.55.3/24' ],
  }

  keepalived::vrrp::sync_group { 'VG_1':
    members => ['VI_50', 'VI_55']
  }
}

node /entry2/ {
  include keepalived

  keepalived::vrrp::instance { 'VI_50':
    interface         => 'eth1',
    state             => 'BACKUP',
    virtual_router_id => '50',
    priority          => '100',
    virtual_ipaddress => [ '192.168.50.3/24' ],
  }

  keepalived::vrrp::instance { 'VI_55':
    interface         => 'eth2',
    state             => 'BACKUP',
    virtual_router_id => '55',
    priority          => '100',
    virtual_ipaddress => [ '192.168.55.3/24' ],
  }

  keepalived::vrrp::sync_group { 'VG_1':
    members => ['VI_50', 'VI_55']
  }


}



# set up our firewall

include ferm

# allow ipv4 forwarding

sysctl { 'net.ipv4.ip_forward': value => '1' }
