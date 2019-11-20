#!/bin/bash

# Synchronize the database from prod to dev.

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

DEV_PLATFORM="${DEV_PLATFORM:=/var/aegir/platforms/civicrm-d8}"
PROD_PLATFORM="${PROD_PLATFORM:=/var/aegir/platforms/civicrm-d8}"

if [ ! -f "$PROD_PLATFORM/sites/$SITE_SRC/settings.php" ]; then
  echo "Prod: $PROD_PLATFORM/sites/$SITE_SRC is not a valid Drupal directory"
  exit 1
fi

if [ ! -f "$DEV_PLATFORM/sites/$SITE_DEST/settings.php" ]; then
  echo "Dev: $DEV_PLATFORM/sites/$SITE_DEST is not a valid Drupal directory"
  exit 1
fi

SITE_SRC="@$SITE_SRC"
SITE_DEST="@$SITE_DEST"

# be verbose
set -x

# stop on first error
set -e

cd /tmp/

sqlfile=`mktemp --suffix=.sql`

drush $SITE_SRC sql-dump > $sqlfile
perl -pi -e 's#\/\*\!5001[7|3].*?`[^\*]*\*\/##g' $sqlfile

cat $sqlfile | drush $SITE_DEST sqlc

rm $sqlfile

# Set an image so that users notice the difference between prod and formation.
DATE=`date +%Y-%m-%d`
SITE="** DEV **"
wget -O $DEV_PLATFORM/sites/${SITE_DEST:1}/files/symbiotic-dev-version-tmp.jpg  "http://lorempixel.com/mono/640/280/food"
convert -pointsize 80 -fill '#0099FF' -stroke black -strokewidth 2  -annotate +15+100 "$SITE\n$DATE" $DEV_PLATFORM/sites/${SITE_DEST:1}/files/symbiotic-dev-version-tmp.jpg $DEV_PLATFORM/sites/${SITE_DEST:1}/files/symbiotic-dev-version.jpg
rm $DEV_PLATFORM/sites/${SITE_DEST:1}/files/symbiotic-dev-version-tmp.jpg

# Verify takes care of detecting that it's a dev site and updating the environment
# and other settings.
drush $SITE_DEST provision-verify

echo "All done."
