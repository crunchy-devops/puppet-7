# Puppet Common Usage 

![usage](screenshot/usage.png)


## Files
### Create file 
see examples in FIRST_MANIFESTS.md line 109-139
### Delete
see examples in FIRST_MANIFESTS.md  line 109-139

### Modify
see examples in FILE_LINE.md
#### Know more
File is backed up before being replaced.  
```puppet
class essai::example (
  Stdlib::Absolutepath $file = '/tmp/puppet-example',
  String[1] $content = 'Hello World with backup!',
) {
  file { $file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $content,
    backup => '.bck',
  }
}
```
### Configure 
See examples in TEMPLATES.md  

## Packages

### Install git package
```puppet
puppet module install rehan-git 
# Code analysis

```












