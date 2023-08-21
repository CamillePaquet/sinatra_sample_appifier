%%APPLICATION%%::%%NAMESPACE%%.delete '/message/:id' do |id|
  Message.find(id).delete
end

%%APPLICATION%%::%%NAMESPACE%%.get '/message/:id' do |id|
  @message = Message.find(id)
  render_erb view: :'message/consult'
end