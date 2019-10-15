#!/bin/bash

# Synchronize the database from prod to dev.

SITE_SRC="@$1"
SITE_DEST="@$2"

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

DEV_PLATFORM="${DEV_PLATFORM:=/var/aegir/platforms/wordpress}"
PROD_PLATFORM="${PROD_PLATFORM:=/var/aegir/platforms/wordpress}"

if [ ! -d "$PROD_PLATFORM/sites/$SITE_SRC/wp-content" ]; then
  echo "Prod: $PROD_PLATFORM/sites/$SITE_SRC is not a valid WordPress directory"
  exit 1
fi

if [ ! -d "$DEV_PLATFORM/sites/$SITE_DEST/wp-content" ]; then
  echo "Dev: $DEV_PLATFORM/sites/$SITE_DEST is not a valid WordPress directory"
  exit 1
fi

# be verbose
set -x

# stop on first error
set -e

cd /tmp/

sqlfile=`mktemp --suffix=.sql`

drush $SITE_SRC sql-dump > $sqlfile
perl -pi -e 's#\/\*\!5001[7|3].*?`[^\*]*\*\/##g' $sqlfile

cat $sqlfile | drush $SITE_DEST sqlc

drush @$SITE_SRC wp db export $sqlfile
perl -pi -e 's#\/\*\!5001[7|3].*?`[^\*]*\*\/##g' $sqlfile

cat $sqlfile | drush @$SITE_DEST wp sql cli
rm $sqlfile

drush @$SITE_DEST wp option update home "https://$SITE_DEST"
drush @$SITE_DEST wp option update siteurl "https://$SITE_DEST"

drush @$SITE_DEST wp cv api Setting.create extensionsDir="$DEV_PLATFORM/sites/$SITE_DEST/wp-content/plugins/extensions/"
drush @$SITE_DEST wp cv api Setting.create extensionsURL="https://$SITE_DEST/sites/$SITE_DEST/wp-content/plugins/extensions/"
drush @$SITE_DEST wp cv api Setting.create imageUploadURL="https://$SITE_DEST/sites/$SITE_DEST/wp-content/uploads/civicrm/persist/contribute"
drush @$SITE_DEST wp cv api Setting.create imageUploadDir="$DEV_PLATFORM/sites/$SITE_DEST/wp-content/uploads/civicrm/persist/contribute/"
drush @$SITE_DEST wp cv api Setting.create userFrameworkResourceURL="https://$SITE_DEST/wp-content/plugins/civicrm/civicrm"
drush @$SITE_DEST wp cv api Setting.create customFileUploadDir="$DEV_PLATFORM/sites/$SITE_DEST/wp-content/uploads/civicrm/custom/"
drush @$SITE_DEST wp cv api Setting.create uploadDir="$DEV_PLATFORM/sites/$SITE_DEST/wp-content/uploads/civicrm/upload"

drush @$SITE_DEST wp cv api Extension.refresh
drush @$SITE_DEST wp cv api System.flush
drush @$SITE_DEST wp cache flush

# Set an image so that users notice the difference between prod and formation.
DATE=`date +%Y-%m-%d`
SITE="** DEV **"
wget -O $DEV_PLATFORM/sites/$SITE_DEST/wp-content/uploads/symbiotic-dev-version-tmp.jpg  "http://lorempixel.com/mono/640/280/food"
convert -pointsize 80 -fill '#0099FF' -stroke black -strokewidth 2  -annotate +15+100 "$SITE\n$DATE" $DEV_PLATFORM/sites/$SITE_DEST/wp-content/uploads/symbiotic-dev-version-tmp.jpg $DEV_PLATFORM/sites/$SITE_DEST/wp-content/uploads/symbiotic-dev-version.jpg
rm $DEV_PLATFORM/sites/$SITE_DEST/wp-content/uploads/symbiotic-dev-version-tmp.jpg

# Verify takes care of detecting that it's a dev site and updating the environment
# and other settings.
# (Does not work on WordPress for now)
# drush $SITE_DEST provision-verify

echo "All done."
