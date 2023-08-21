


describe 'Posts REST API' do
  before :all do
    $service = RestService::new :service => %%APPLICATION%%::%%NAMESPACE%%
    $data = { "code" => 200,
              "description" => "Successful HTTP Request",
              "data" => {
                "name" => "PPA DEV",
                "version" => "0.9.0",
                "status" => "OK",
                "backends" => {
                  "mongodb" => { "status" => "OK" },
                  "redis" => { "status" => "OK" }
                }
              }
            }
  end

  subject { $service }
  context "GET /api/generic/status : test for status" do
    it { expect(subject.get('/api/generic/status')).to be_correctly_sent }
    it { expect(subject).to respond_with_status 200 }
    it { expect(subject).to respond_a_record }
    it { expect(subject).to respond_with_data($data)}
  end
end
