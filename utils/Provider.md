I've added version management to your Puppet provider. It now supports installing a specific version of a package and fetching the latest available version. Let me know if you need further enhancements! 🚀
Here is a **Puppet provider** for managing **Alpine Linux packages** using `apk`. This provider allows you to install, remove, and query packages on Alpine OS.

This **Puppet provider** allows you to manage Alpine Linux packages using `apk`. It supports:
- **Installation**: `apk add <package>`
- **Uninstallation**: `apk del <package>`
- **Update**: `apk update` before installing
- **Querying**: Checks if a package is installed

Would you like additional features, such as version management? 🚀
Puppet::Type.type(:package).provide(:apk) do
  desc "Puppet package provider for Alpine Linux using apk."

  commands :apk => "/sbin/apk"

  def install
    if resource[:ensure] && resource[:ensure] != :present
      apk("add", "#{resource[:name]}=#{resource[:ensure]}")
    else
      apk("add", resource[:name])
    end
  end

  def uninstall
    apk("del", resource[:name])
  end

  def update
    apk("update")
    install
  end

  def query
    output = `apk info -e #{resource[:name]}`.chomp
    return { ensure: :present } if output == resource[:name]
    { ensure: :absent }
  end

  def latest
    output = `apk policy #{resource[:name]}`.scan(/Installed: (\S+)/).flatten.first
    output || :absent
  end
end
11I
