# Place in /config/puma/production.rb

rails_env = "production"
environment rails_env

app_dir = "/home/deploy/deploy/shared" # Update me with your root rails app path

bind  "unix://#{app_dir}/tmp/sockets/puma.sock"
pidfile "#{app_dir}/tmp/puma.pid"
state_path "#{app_dir}/tmp/puma.state"
directory "#{app_dir}/"

stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

workers 2
threads 1,2

activate_control_app "unix://#{app_dir}/tmp/shared/pumactl.sock"

prune_bundler