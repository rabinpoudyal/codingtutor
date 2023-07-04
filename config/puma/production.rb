environment 'production'

workers 2
threads 1, 6

app_dir = File.expand_path("../../../../../", __FILE__)
shared_dir = "#{app_dir}/shared"

bind "unix://#{shared_dir}/tmp/sockets/puma.sock"
pidfile "#{shared_dir}/tmp/pids/puma.pid"
state_path "#{shared_dir}/tmp/pids/puma.state"

stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

activate_control_app "unix://#{shared_dir}/tmp/sockets/pumactl.sock"

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end