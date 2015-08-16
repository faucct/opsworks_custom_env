# Accepts:
#   application (application name)
#   deploy (hash of deploy attributes)
#   env (hash of custom environment settings)
# 
# Notifies a "restart Rails app <name> for custom env" resource.
require 'yaml'

define :custom_env_template do
  
  path = "#{params[:deploy][:deploy_to]}/shared/config"
  
  directory path do
    owner params[:deploy][:user]
    group params[:deploy][:group]
    mode "0660"
    recursive true
  end
  
  execute 'chmod deploy_to directory' do
    command "chown -Rf #{params[:deploy][:user]} . && chmod -Rf 0660 ."
    cwd params[:deploy][:deploy_to]
  end
  
  file "#{path}/application.yml" do
    content YAML.dump params[:env]
    owner params[:deploy][:user]
    group params[:deploy][:group]
    mode "0660"
    begin
      notifies :run, resources(:execute => "restart Rails app #{params[:application]} for custom env")
    rescue Chef::Exceptions::ResourceNotFound
    end
  end
  
end
