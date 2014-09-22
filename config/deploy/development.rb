
# Userid used for deployment
ask :user, 'for deployment to user@hostname'

# Server deployed to
ask :hostname, 'for deployment to user@hostname'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

# set the server variable
server fetch(:hostname), user: fetch(:user), roles: %w{app}
Capistrano::OneTimeKey.generate_one_time_key!

