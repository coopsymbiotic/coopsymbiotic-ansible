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

if [ -d ./wp-content/uploads/civicrm ]; then
  chown -R aegir.www-data ./wp-content/uploads/civicrm/
  chmod -R g+w ./wp-content/uploads/civicrm/
fi

if [ -d ./wp-content/plugins/files/civicrm ]; then
  chown -R aegir.www-data ./wp-content/plugins/files/civicrm/
  chmod -R g+w ./wp-content/plugins/files/civicrm/
fi
