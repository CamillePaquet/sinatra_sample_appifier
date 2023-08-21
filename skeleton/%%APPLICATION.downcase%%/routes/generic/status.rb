

%%APPLICATION%%::%%NAMESPACE%%.namespace '/api/generic' do
  get '/status' do
    return secure_api_return status_key: :success, structured: true do 
      status = StatusSerializer::new
      #raise SpecificError::new status_key: :error_service_unavailable if status[:status]  ==  'KO'
      status
    end
  end
end