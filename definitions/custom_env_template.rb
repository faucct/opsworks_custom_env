# Accepts:
#   application (application name)
#   deploy (hash of deploy attributes)
#   env (hash of custom environment settings)
# 
# Notifies a "restart Rails app <name> for custom env" resource.
require 'yaml'

define :custom_env_template do
  
  directory "#{params[:deploy][:deploy_to]}/shared/config" do
    owner params[:deploy][:user]
    group params[:deploy][:group]
    mode "0660"
    recursive true
  end
  
  file "#{params[:deploy][:deploy_to]}/shared/config/application.yml" do
    content YAML.dump params[:env]
    owner params[:deploy][:user]
    group params[:deploy][:group]
    mode "0660"
    notifies :run, resources(:execute => "restart Rails app #{params[:application]} for custom env")
  end
  
end
