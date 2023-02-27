# HIERA
Puppet utilise Hiera pour faire deux choses :
1. Stocker les données de configuration avec des paires clé-valeur
2. Rechercher les données dont un module particulier a besoin pour un nœud donné lors de la compilation du catalogue

La configuration par defaut de l'environnement Hiera utilise un fichier, data/common.yaml, pour fournir 
des valeurs de paramètres.  

## Utilisation 
```shell
cd /etc/puppetlabs/code/environments/production/modules/webforce
pdk new class exercice3
```
Dans exercice3.pp, copier le code suivant
```puppet
class webforce::exercice3 (String $greeting) {
    file { '/tmp/my_parameters':
          ensure => 'present',
          content => $greeting,
          path => '/tmp/my_parameters',
      }
}
```

dans ```cd /etc/puppetlabs/code/environments/production/modules/webforce/data```  
ajoutez dans common.yaml  
```yaml
---
webforce::exercice3::greeting: Hola Mundo
```

go to ENVIRONMENTS.md


