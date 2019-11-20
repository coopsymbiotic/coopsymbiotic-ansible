#!/bin/bash

# Synchronize the database from prod to dev.

if [ -z "$SITE_SRC" ]; then
  echo "SITE_SRC is not set"
  exit 1
fi

if [ -z "$SITE_DEST" ]; then
  echo "SITE_DEST is not set"
  exit 1
fi

function usage() {
  echo "Usage: resync-drupal-db.sh prod.example.org dev.example.org"
  exit 1
}

if [ -z $SITE_SRC ]; then
  echo "Missing arguments: src and dest."
  usage
fi

if [ -z $SITE_DEST ]; then
  echo "Missing arguments: dest."
  usage
fi

DEST_PLATFORM="${DEST_PLATFORM:=/var/aegir/platforms/wordpress}"
SRC_PLATFORM="${SRC_PLATFORM:=/var/aegir/platforms/wordpress}"

if [ ! -d "$SRC_PLATFORM/sites/$SITE_SRC/wp-content" ]; then
  echo "Prod: $SRC_PLATFORM/sites/$SITE_SRC is not a valid WordPress directory"
  exit 1
fi

if [ ! -d "$DEST_PLATFORM/sites/$SITE_DEST/wp-content" ]; then
  echo "Dev: $DEST_PLATFORM/sites/$SITE_DEST is not a valid WordPress directory"
  exit 1
fi

# be verbose
set -x

# stop on first error
set -e

cd /tmp/

sqlfile=`mktemp --suffix=.sql`

drush "@$SITE_SRC" wp db export $sqlfile
perl -pi -e 's#\/\*\!5001[7|3].*?`[^\*]*\*\/##g' $sqlfile

cat $sqlfile | drush @$SITE_DEST wp sql cli
rm $sqlfile

drush @$SITE_DEST wp option update home "https://$SITE_DEST"
drush @$SITE_DEST wp option update siteurl "https://$SITE_DEST"

drush @$SITE_DEST wp cv api Setting.create extensionsDir="$DEST_PLATFORM/sites/$SITE_DEST/wp-content/plugins/extensions/"
drush @$SITE_DEST wp cv api Setting.create extensionsURL="https://$SITE_DEST/sites/$SITE_DEST/wp-content/plugins/extensions/"
drush @$SITE_DEST wp cv api Setting.create imageUploadURL="https://$SITE_DEST/sites/$SITE_DEST/wp-content/uploads/civicrm/persist/contribute"
drush @$SITE_DEST wp cv api Setting.create imageUploadDir="$DEST_PLATFORM/sites/$SITE_DEST/wp-content/uploads/civicrm/persist/contribute/"
drush @$SITE_DEST wp cv api Setting.create userFrameworkResourceURL="https://$SITE_DEST/wp-content/plugins/civicrm/civicrm"
drush @$SITE_DEST wp cv api Setting.create customFileUploadDir="$DEST_PLATFORM/sites/$SITE_DEST/wp-content/uploads/civicrm/custom/"
drush @$SITE_DEST wp cv api Setting.create uploadDir="$DEST_PLATFORM/sites/$SITE_DEST/wp-content/uploads/civicrm/upload"

drush @$SITE_DEST wp cv api Extension.refresh
drush @$SITE_DEST wp cv api System.flush
drush @$SITE_DEST wp cache flush

# Set an image so that users notice the difference between prod and formation.
DATE=`date +%Y-%m-%d`
SITE="** DEV **"
wget -O $DEST_PLATFORM/sites/$SITE_DEST/wp-content/uploads/symbiotic-dev-version-tmp.jpg  "http://lorempixel.com/mono/640/280/food"
convert -pointsize 80 -fill '#0099FF' -stroke black -strokewidth 2  -annotate +15+100 "$SITE\n$DATE" $DEST_PLATFORM/sites/$SITE_DEST/wp-content/uploads/symbiotic-dev-version-tmp.jpg $DEST_PLATFORM/sites/$SITE_DEST/wp-content/uploads/symbiotic-dev-version.jpg
rm $DEST_PLATFORM/sites/$SITE_DEST/wp-content/uploads/symbiotic-dev-version-tmp.jpg

# Verify takes care of detecting that it's a dev site and updating the environment
# and other settings.
# (Does not work on WordPress for now)
# drush $SITE_DEST provision-verify

echo "All done."
