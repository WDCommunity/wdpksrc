# How to create an app

## Required files

Create a directory with these files

* `before_apkg.sh` - Pre installation script
* `install.sh` - Installation script
* `init.sh` - Initialize script: prepares app icon, index page and paths. 
  Often creates a symlink in /var/www redirecting to a service running on another port.
  Use this to restore custom paths and settings on reboot.
* `start.sh` - Starts the application when enabled (e.g. on boot). 
  When no index page is defined in apkg.rc, the enable button is greyed out.
* `stop.sh` - Stops the application when disabled (e.g. on shutdown). 
  When no index page is defined in apkg.rc, the disable button is greyed out.
* `clean.sh` - Cleanup script to revert the initialize step. Ensures a 
  clean shutdown.
* `remove.sh` - Removes all the app completely. Remember to make backups 
  of configs/data here to support upgrade.
* `apkg.rc` - App description goes here. The mksapkg tool converts this 
  to xml and creates a apkg.sign signature (openssl blowfish md5 checksum of the app name).

Other files in the directory will be included automatically as well.

Creating a `build.sh` script is interesting for the `build_and_install` tool at the root of this project, 
but you can run mksapkg manually too.

## Working with OS3

The root filesystem is a squashfs: an image loaded into memory. Any change you make is reverted on boot. 
Only data on the shares (`/mnt/HD` or `/shares`) is persistent.


