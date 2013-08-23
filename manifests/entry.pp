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
    members => ['VI_50', 'VI_55'],
    notify_master => "/etc/conntrackd/primary-backup.sh primary",
    notify_backup => "/etc/conntrackd/primary-backup.sh backup",
    notify_fault => "/etc/conntrackd/primary-backup.sh fault",
  }


  class { "conntrackd::config":
      protocol => 'UDP',
      sync_mode => 'ALARM',
      interface => 'eth2',
      ipv4_address => '192.168.55.1',
      udp_ipv4_dest => '192.168.55.2',
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
    members => ['VI_50', 'VI_55'],
    notify_master => "/etc/conntrackd/primary-backup.sh primary",
    notify_backup => "/etc/conntrackd/primary-backup.sh backup",
    notify_fault => "/etc/conntrackd/primary-backup.sh fault",
  }
   
  class { "conntrackd::config":
      protocol => 'UDP',
      interface => 'eth2',
      sync_mode => 'ALARM',
      ipv4_address => '192.168.55.2',
      udp_ipv4_dest => '192.168.55.1',
  }


}


file { "/etc/conntrackd/primary-backup.sh":
    source  => "puppet:///modules/conntrackd/primary-backup.sh",
            owner   => root,
            group   => root,
            mode    => 0755,
}


# set up our firewall

include ferm

# allow ipv4 forwarding

sysctl { 'net.ipv4.ip_forward': value => '1' }
