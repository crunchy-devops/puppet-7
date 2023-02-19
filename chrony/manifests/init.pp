# chrony/manifests/init.pp
class chrony  {
  package { 'chrony':
    ensure => 'installed',
  }
  service { 'chronyd':
    ensure => 'running',
    enable => true,
    require => Package['chrony'],
  }
  file { '/etc/chrony.conf':
    ensure => file,
    content => file('chrony/chrony.conf'),
    notify => Service['chronyd'],
  }
}
# grep -vE '^(#|$)' /etc/chrony.conf >