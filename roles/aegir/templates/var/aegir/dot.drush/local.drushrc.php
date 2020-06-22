<?php

// {{ ansible_managed }}

// Disable composer support from Aegir, it can cause surprises
// when Aegir is updated and runs verify on all platforms (which then updates
// all platforms).
$options['provision_composer_install_platforms'] = FALSE;
