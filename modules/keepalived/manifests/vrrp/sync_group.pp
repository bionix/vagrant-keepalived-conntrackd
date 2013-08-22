# == Define: keepalived::vrrp::sync_group
#
# === Parameters:
#
#
# $members::         Define sync_group members
#
define keepalived::vrrp::sync_group (
  $members,
) {
  concat::fragment { "keepalived.conf_vrrp_sync_group_${name}":
    ensure  => $ensure,
    target  => "${keepalived::config_dir}/keepalived.conf",
    content => template('keepalived/vrrp_sync_group.erb'),
    order   => 100,
  }
}

