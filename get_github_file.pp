define remote_file($remote_location=undef, $mode='0644'){
  exec{"retrieve_${title}":
    command => "/usr/bin/wget -q ${remote_location} -O ${title}",
    creates => $title,
  }

  file{$title:
    mode    => $mode,
    require => Exec["retrieve_${title}"],
  }
}

remote_file{'/home/vagrant/README.md':
  remote_location => 'https://raw.githubusercontent.com/crunchy-devops/puppet-7/main/README.md',
  mode            => '0755',
}