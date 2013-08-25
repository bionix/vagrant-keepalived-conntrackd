Package { ensure => "installed" }

$packages = [ "telnet", "ifupdown-extra", "vim" ]
package { $packages: }

network_route { '192.168.55.0':
  ensure    => 'present',
  gateway   => '192.168.50.3',
  interface => 'eth1',
  netmask   => '255.255.255.0',
  network   => '192.168.55.0'
}

exec { "IFACE=eth1 VERBOSITY=1 MODE=start bash /etc/network/if-up.d/20static-routes":
    provider => 'shell',
     require => Package['ifupdown-extra'],
}
