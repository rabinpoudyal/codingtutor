# Place in /config/puma/production.rb

rails_env = "production"
environment rails_env

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

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