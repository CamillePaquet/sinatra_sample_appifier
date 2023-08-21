
%%APPLICATION%%::%%NAMESPACE%%.get '/' do
    render_erb view: :index
end

%%APPLICATION%%::%%NAMESPACE%%.get '/anonymous' do
  render_erb view: :index
end
