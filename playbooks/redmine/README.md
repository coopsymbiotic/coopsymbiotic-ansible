Don't rely on this playbook too much, and read the main.yml.

Misc notes:

If you run into the error: "Gem::LoadError: You have already activated rack 1.6.2, but your Gemfile requires rack 1.5.4."

* Try: `# gem list  | grep rack`
* if 1.6.2 is in there, try: `/var/lib/gems/2.1.0/gems/rack-1.6.2/`
* if you have other ruby applications that really need 1.6.2, try: changing the init script to use: `su -l $USER -c "cd $SYSTEM_REDMINE_PATH; bundle exec puma --daemon [...]"`
