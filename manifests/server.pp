Package { ensure => "installed" }

$packages = [ "telnet", "ifupdown-extra", "vim" ]
package { $packages: }


network_route { '192.168.50.0':
  ensure    => 'present',
  gateway   => '192.168.55.3',
  interface => 'eth1',
  netmask   => '255.255.255.0',
  network   => '192.168.50.0'
}

exec { "IFACE=eth1 VERBOSITY=1 MODE=start bash /etc/network/if-up.d/20static-routes":
    require => Package['ifupdown-extra'],
    provider => 'shell'
}

include inetd
file { "/etc/inetd.conf":
    source  => "puppet:///modules/inetd/inetd.conf",
    owner   => 'root',
    group   => 'root',
    notify => Service["openbsd-inetd"],
    require => Package["openbsd-inetd"],
}
