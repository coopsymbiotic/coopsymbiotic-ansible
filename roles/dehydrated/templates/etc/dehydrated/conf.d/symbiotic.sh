# {{ ansible_managed }}

# Run these hooks after renewals
HOOK="${BASEDIR}/hooks.sh"

# Skip over errors during certificate orders (ex: if one cert is failing, keep going)
KEEP_GOING=yes
