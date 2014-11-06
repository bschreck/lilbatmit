set :stage, :production

set :full_app_name, "#{fetch(:application)}"
set :server_name, "lilbatmit.com"

server '23.253.151.159', user: 'deploy', roles: %w{web app db}, primary: true

set :deploy_to, "/u/apps/#{fetch(:full_app_name)}"

set :rails_env, :production

set :ssh_options, {
  forward_agent: true,
}
