# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.17.1'

set :application, 'deploy'
set :repo_url, 'git@github.com:rabinpoudyal/codingtutor.git'
set :ssh_options, { forward_agent: true, user: 'deploy', keys: %w(~/.ssh/id_ed25519) }

set :deploy_to, '/home/deploy/deploy'

set :pty,             true
# set :use_sudo,        false
# set :deploy_via,      :remote_cache
# set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
# set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
# set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
# set :puma_access_log, "#{release_path}/log/puma.error.log"
# set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_workers, 4
set :puma_threads, [0, 8]
set :puma_worker_timeout, 300
# set :puma_init_active_record, false  # Change to true if using ActiveRecord
set :puma_preload_app, false
set :puma_prune_bundler, true
set :puma_restart_command, 'bundle exec pumactl phased-restart' # This is for 0 downtime
set :puma_control_app, true
set :rvm_path, '/home/deploy/.rvm'
# set :rvm_custom_path, '/home/deploy/.rvm'
set :rvm_bin_path, '/home/deploy/.rvm/bin'

set :rvm_type, :user

# Default value for linked_dirs is []
append :linked_dirs,
       'log',
       'tmp/pids',
       'tmp/sockets',
       'public/system',
       'tmp/cache',
       'public/packs',
       'node_modules',
       'keys'

append :linked_files, '.env'

# Default value for keep_releases is 5
set :keep_releases, 10

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  desc 'Generate Puma binstubs'
  task :generate_binstubs do
    on roles(:app) do
      within release_path do
        execute "bundle binstubs puma --force"
      end
    end
  end

  before :start, :make_dirs, :generate_binstubs
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'puma:phased-restart', 'puma:start'
      invoke 'deploy'
    end
  end

  task :restart_nginx do
    on roles(:web) do
      execute :sudo, :service, 'nginx reload'
    end
  end

  before :publishing, 'puma:config' # Upload puma configuration to server
  before :publishing, 'puma:nginx_config' # Upload nginx configuration to server

  # after :finishing, 'deploy:on_finished_tasks'
  after :finishing, :cleanup
  after 'puma:restart', 'deploy:restart_nginx'

  before 'deploy:assets:precompile', 'deploy:yarn_install'
  namespace :deploy do
    desc 'Run rake yarn install'
    task :yarn_install do
      on roles(:web) do
        within release_path do
          # invoke 'dotenv:read'
          # invoke 'dotenv:check'
          # invoke 'dotenv:setup'
          # invoke 'dotenv:hook'
          execute("cd #{release_path} && yarn install --production --silent --no-progress --no-audit --no-optional")
        end
      end
    end
  end
end