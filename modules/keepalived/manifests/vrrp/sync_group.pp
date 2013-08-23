# == Define: keepalived::vrrp::sync_group
#
# === Parameters:
#
#
# $members::        Define sync_group members
# $notify_master    Script to call on master events
#                   Default: undef
# $notify_backup    Script to call on backup events
#                   Default: undef
# $notify_fault     Script to call on fault events
#                   Default: undef

define keepalived::vrrp::sync_group (
  $members,
  $notify_master = undef,
  $notify_backup = undef,
  $notify_fault = undef,
) {
  concat::fragment { "keepalived.conf_vrrp_sync_group_${name}":
    ensure  => $ensure,
    target  => "${keepalived::config_dir}/keepalived.conf",
    content => template('keepalived/vrrp_sync_group.erb'),
    order   => 100,
  }
}

