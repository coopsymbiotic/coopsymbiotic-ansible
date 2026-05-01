# {{ ansible_managed }}

# Run these hooks after renewals
HOOK="/etc/dehydrated/hooks.sh"

# Skip over errors during certificate orders (ex: if one cert is failing, keep going)
KEEP_GOING=yes
