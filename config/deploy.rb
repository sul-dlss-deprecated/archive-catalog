# config valid only for Capistrano 3.x
lock '3.2.1'

set :application, 'archive-catalog'
set :repo_url, 'https://github.com/sul-dlss/archive-catalog.git'

# Default branch = whatever is currently checked out
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Userid used for deployment
ask :user, 'for deployment to user@hostname'

# Server deployed to
ask :hostname, 'for deployment to user@hostname'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

# set the server variable
server fetch(:hostname), user: fetch(:user), roles: %w{app}

Capistrano::OneTimeKey.generate_one_time_key!

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w(log tmp config/environments)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

end
