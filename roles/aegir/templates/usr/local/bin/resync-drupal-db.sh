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
SKIP_TABLES="${SKIP_TABLES:=watchdog,civicrm_log,civicrm_mailing_recipients,civicrm_mailing_event_bounce,civicrm_mailing_event_confirm civicrm_mailing_event_delivered civicrm_mailing_event_forward civicrm_mailing_event_opened civicrm_mailing_event_queue civicrm_mailing_event_reply civicrm_mailing_event_subscribe civicrm_mailing_event_trackable_url_open civicrm_mailing_event_unsubscribe}"

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

drush $SITE_SRC sql-dump --skip-tables-list $SKIP_TABLES > $sqlfile
perl -pi -e 's#\/\*\!5001[7|3].*?`[^\*]*\*\/##g' $sqlfile

cat $sqlfile | drush $SITE_DEST sqlc

rm $sqlfile

# Verify takes care of detecting that it's a dev site and updating the environment
# and other settings.
drush $SITE_DEST provision-verify

# To avoid weird issues because we patch against flushing this
drush $SITE_DEST sqlq 'TRUNCATE civicrm_cache;'

echo "All done."
