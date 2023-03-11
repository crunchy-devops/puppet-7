# Exec or not 

Exec est une solution rapide de codage, une façon d'obtenir le fichier que vous voulez sans extraire l'intégralité 
du référentiel Git.

```puppet
exec{'get_github_file':
command => "/usr/bin/wget -q https://raw.githubusercontent.com/crunchy-devops/puppet-7/main/README.md -O /home/vagrant/README.md",
creates => "/home/vagrant/README.md",
}

file{'/home/vagrant/README.md':
mode => '0755',
require => Exec["get_github_file"],
}
```

Bien que l'utilisation d'exec soit quelque peu mal vue, elle peut être utilisée efficacement pour créer vos propres types.
Voir get_github_file.pp
