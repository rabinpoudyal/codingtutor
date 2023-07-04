# frozen_string_literal: true

set :stage, :production
set :branch, 'main'
set :rails_env, 'production'

role :app, %w[deploy@170.64.165.188]
role :web, %w[deploy@170.64.165.188]
role :db,  %w[deploy@170.64.165.188]

# Define server(s)
server '170.64.165.188', user: 'deploy', roles: %w[web app]

set :nginx_server_name, 'codingtutor.online'
set :nginx_config_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :nginx_flags, 'fail_timeout=0'
set :nginx_http_flags, fetch(:nginx_flags)
set :nginx_ssl_certificate, '/etc/letsencrypt/live/codingtutor.online/fullchain.pem'
set :nginx_ssl_certificate_key, '/etc/letsencrypt/live/codingtutor.online/privkey.pem'
set :nginx_use_ssl, true
set :nginx_use_http2, false
set :nginx_downstream_uses_ssl, false
set :attach_response_time_in_log, true
set :env_file, '.env.production'
# set :default_shell, '/bin/bash -l'


set :ssh_options, {
  forward_agent: true,
  user: 'deploy'
}