# EXERCICES


## EXERCICE 1
Create un module nomme essai avec PDK dans la directory production de Puppet.
placez le code suivant 
```puppet
# @summary An example class
# @param file
#   The file to manage
# @param content
#   The content in the file
class example (
Stdlib::Absolutepath $file = '/tmp/puppet-example',
String[1] $content = 'Hello World!',
) {
file { $file:
ensure  => file,
owner   => 'root',
group   => 'root',
mode    => '0644',
content => $content,
}
}
```
faire un pdk validate et eliminez les warnings et erreurs  
creez dans production/manifests un fichier init.pp qui execute le module 



