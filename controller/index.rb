# Application::PPAService.namespace '/' do
Application::PPAService.get '/' do
    render_erb view: :index
end

Application::PPAService.get '/anonymous' do
  render_erb view: :index
end
# end
