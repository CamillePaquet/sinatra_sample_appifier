# encoding: UTF-8
Application::PPAService.namespace '/api/generic' do
  before do

    content_type 'application/json'
  end
end

Application::PPAService.namespace '/api/v1' do

  before do
    content_type 'application/json'
    protect! 'Authentification required' if get_config.api.auth == true
  end

end
Dir[File.dirname(__FILE__) + '/generic/*.rb'].each {|file| require file  unless File.basename(file) == 'init.rb'}
Dir[File.dirname(__FILE__) + '/v1/*.rb'].each {|file| require file  unless File.basename(file) == 'init.rb'}
