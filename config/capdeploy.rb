#Приложение
set :application, "chart.icfdev.ru"

#Репозиторий
set :scm, :git
set :repository,  "git@github.com:BrandyMint/chart_test.git"
set :deploy_via, :remote_cache
set :scm_verbose, true
ssh_options[:forward_agent] = true

#Сервер
server 'icfdev.ru', :app, :web, :db, :primary => true
set(:current_branch) { `git branch`.match(/\* (\S+)\s/m)[1] || raise("Couldn't determine current branch") }
set :branch, defer { current_branch } unless exists?(:branch)
set :rails_env, "stage"

#Учетные данные на сервере
set :user,      'wwwdata'
set :deploy_to,  defer { "/home/#{user}/#{application}" }
set :use_sudo,   false

#Все остальное
set :keep_releases, 5
set :shared_children, fetch(:shared_children) + %w(public/uploads)

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system
set :rvm_type, :user

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
before 'deploy:restart', 'deploy:migrate'
after 'deploy:restart', "deploy:cleanup"

#RVM, Bundler
require "rvm/capistrano"
require "bundler/capistrano"
require "recipes0/init_d/unicorn"
require "recipes0/nginx"

