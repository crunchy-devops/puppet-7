# PDK 
Create high-quality modules with Puppet Development Kit (PDK).  
PDK provides integrated testing tools and a command line interface to help you develop, validate, and test modules.  

## Installer le pdk 
```shell
sudo apt install -y pdk
```

## Creer l'arborescence d'un nouveau module
```shell
cd /etc/puppetlabs/code/environments/main/modules
pdk new module webforce
```
Les classes sont des blocs nommés de code Puppet qui sont stockés dans des modules et appliqués ultérieurement  
lorsqu'ils sont appelés par leur nom. Vous pouvez ajouter des classes au catalogue d'un nœud en les déclarant   
dans vos manifestes ou en les affectant à partir d'un classificateur de nœud externe (ENC).   
Les classes configurent généralement des blocs de fonctionnalités volumineux ou moyens,   
tels que tous les packages, fichiers de configuration et services nécessaires à l'exécution d'une application.  

```shell
cd webforce
pdk new class exercice1
```
Change le script cd /etc/puppetlabs/code/environments/main/modules/webforce/exercice1.pp
```puppet
# @summary Create temporary file
# 
# Create temporary file
#
# @example
# include my_module::my_class
class webforce::exercice1 {
  file { '/tmp/hello':
    ensure => file,
    content => 'Hello World',
    path => '/tmp/hello',
  } 
}
```
Vous pouvez valider le module avec :   
```shell
cd ..   # you need to be in the webforce module directory
pdk validate # Check syntax and other stuff
```

## Creer le Site Manifest 
Puppet commence à compiler un catalogue soit avec un seul fichier manifeste, soit avec un répertoire de manifestes qui 
sont traités comme un seul fichier. Ce point de départ est appelé manifest principal ou site manifest.  
Change de directory ```cd /etc/puppetlabs/code/environments/production/manifest```    

Creez un fichier site.pp  
```puppet
node default {
      include webforce::exercice1
  }
```

and check 
```shell
puppet agent -t
```

Nous allons creer une autre classe 
```shell
cd webforce/    # se placer dans la directory du module
pdk new class exercice2 # executez la creation d'une autre classe
cd manifests/   # se placer dans la directory manifests
vi exercice2.pp  # editez le fichier pp de la nouvelle classe
```
Copier la code suivant 
```puppet
class webforce::exercice2 {
  file { '/tmp/another':
      ensure => file,
      content => 'Another Hello World',
      path => '/tmp/another',
    }
}
```
Changez de directory ```cd /etc/puppetlabs/code/environments/production/modules/webforce```

```shell
pdk new class webforce
```
Le fichier init.pp est genere  
Copiez et collez 
```puppet
class webforce {
  include webforce::exercice1
  include webforce::exercice2
}
```

Changez de directory ```cd /etc/puppetlabs/code/environments/production/manifests```  
changez le fichier site.pp
```puppet
node default { 
  include webforce
}
```

go to HIERA.md 

