Don't rely on this playbook too much, and read the main.yml.

Misc notes:

If you run into the error: "Gem::LoadError: You have already activated rack 1.6.2, but your Gemfile requires rack 1.5.4."

* Try: `# gem list  | grep rack`
* if 1.6.2 is in there, try: `/var/lib/gems/2.1.0/gems/rack-1.6.2/`
* if you have other ruby applications that really need 1.6.2, try: changing the init script to use: `su -l $USER -c "cd $SYSTEM_REDMINE_PATH; bundle exec puma --daemon [...]"`

If you run into this error when doing the "bundle install" for redmine_git_hosting: "The git source https://github.com/jbox-web/gitolite-rugged.git is not yet checked out. Please run `bundle install` before trying to start your application".. and yet, 'bundle install' just doesn't fix it...

* edit plugins/redmine_git_hosting/Gemfile
* replace the gitolite-rugged reference to just: `gem 'gitolite-rugged'`

I also had issues with gitlab-grack and the redcarpet version.. so I ended up commenting them out, since I don't use Gitlab.

If you're having weird issues with gitolite, but the redmine_git_hosting "Config Test" is all green, make sure that the "Rugged" features include "ssh" (not just https and threads). If not, you probably forgot some dependancies (http://redmine-git-hosting.io/get_started/) and need to re-install the rugged gem.
