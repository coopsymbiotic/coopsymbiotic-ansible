<?php

// {{ ansible_managed }}

// Disable composer support from Aegir, it can cause surprises
// when Aegir is updated and runs verify on all platforms (which then updates
// all platforms).
$options['provision_composer_install_platforms'] = FALSE;

// https://www.drupal.org/project/provision/issues/2953349#comment-14038063
$options['provision_db_cloaking'] = FALSE;
