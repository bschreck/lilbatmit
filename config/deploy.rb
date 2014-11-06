# config valid only for Capistrano 3.1
lock '3.2.1'


set :application, 'lilb'
set :deploy_user, 'deploy'
set :repo_url, 'git@github.com:bschreck/lilbatmit.git'

set :branch, "master"

set :deploy_to, '/u/apps'

set :bundle_flags, "--deployment --quiet --binstubs"

set :default_env, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:/opt/rbenv/shims:$PATH"
}

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml}

set :bundle_binstubs, nil
# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc "Create Cron Log"
  task :cron_log do |t|
    on roles(:db) do
      within release_path do
        execute(:touch, "log/cron.log")
      end
    end
  end

  desc "bring database to current version"
  task :migrate do
    on roles(:db) do
      within release_path do
        with path: "$HOME/.rbenv/shims:$HOME/.rbenv/bin:/opt/rbenv/shims:$PATH", rails_env: fetch(:rails_env)do
          execute :bundle, :exec, :rake, "db:migrate"
        end
      end
    end
  end


  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :updated, 'deploy:cron_log'

  after :publishing, :migrate
  after :migrate, :cleanup
  after :cleanup, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
