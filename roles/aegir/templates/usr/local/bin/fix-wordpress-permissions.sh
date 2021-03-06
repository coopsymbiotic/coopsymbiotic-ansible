#!/bin/bash

# {{ ansible_managed }}

# Help menu
print_help() {
cat <<-HELP
This script is used to fix the file permissions of a WordPress site. You need
to provide the following argument:

  --site-path: Path to the WordPress site's directory.

Usage: (sudo) ${0##*/} --site-path=PATH
Example: (sudo) ${0##*/} --site-path=/var/aegir/platforms/wordpress/sites/example.org
HELP
exit 0
}

site_path=${1%/}

# Parse Command Line Arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    --site-path=*)
        site_path="${1#*=}"
        ;;
    --help) print_help;;
    *)
      printf "Error: Invalid argument, run --help for valid arguments.\n"
      exit 1
  esac
  shift
done

if [ -z "${site_path}" ] || [ ! -d "${site_path}/wp-content" ] ; then
  printf "Error: Please provide a valid WordPress site directory.\n"
  exit 1
fi

if [ $(id -u) != 0 ]; then
  printf "Error: You must run this with sudo or root.\n"
  exit 1
fi

cd $site_path

# For plugin upgrades, in combination with ssh-sftp-updater-support
mkdir -p ./wp-content/upgrade

if [ -d ./wp-content/upgrade ]; then
  chown -R aegir.www-data ./wp-content/upgrade/
  chmod -R g+w ./wp-content/upgrade/
  find ./wp-content/upgrade/ -type d -exec chmod g+s {} \;
fi

if [ -d ./wp-content/uploads ]; then
  chown -R aegir.www-data ./wp-content/uploads/
  chmod -R g+w ./wp-content/uploads/
  find ./wp-content/uploads/ -type d -exec chmod g+s {} \;
fi

# Legacy CiviCRM directory
if [ -d ./wp-content/plugins/files/civicrm ]; then
  chown -R aegir.www-data ./wp-content/plugins/files/civicrm/
  chmod -R g+s ./wp-content/plugins/files/civicrm/
  find ./wp-content/plugins/files/civicrm/ -type d -exec chmod g+s {} \;
fi
