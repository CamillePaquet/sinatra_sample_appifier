describe 'Posts REST API User' do
  before :all do
    Mongoid.purge!
    get_config.api.auth = false
    $service = RestService::new :service => %%APPLICATION%%::%%NAMESPACE%%
  end

  subject { $service }

  context "GET /api/v1/users : get all users" do
    it { expect(subject.get('/api/v1/users')).to be_correctly_sent }
    it { expect(subject).to respond_with_status 200 }
    it { expect(subject).to respond_a_collection_of_record }
    it { expect(subject).to respond_with_collection_size 0 }
  end

  context "POST /api/v1/user : post user" do
    it {
      user = {
        username: "toto",
        token: 'abcdefghijk',
        profiles: ['user', 'admin'],
        fullname: "Toto Titi",
        email: 'toto@outlook.fr',
        temporary_password: true,
        api_user: true
      }
      expect(subject.post('/api/v1/user',user.to_json)).to be_correctly_sent }
    it { expect(subject).to respond_with_status 201 }
  end


  context "GET /api/v1/user/:username : get user by username" do
    it {
      expect(subject.get('/api/v1/user/toto')).to be_correctly_sent }
      it { expect(subject).to respond_with_status 200 }
      it { expect(subject).to respond_a_record }
  end

  
  context "PUT /api/v1/user : put user by username" do
    it {
      user_to_update = {
        username: "toto",
        token: 'qwertyiop',
        profiles: ['user', 'admin'],
        fullname: "Toto Tutu",
        email: 'toto@outlook.fr',
        temporary_password: true,
        api_user: true
      }
      expect(subject.put('/api/v1/user', user_to_update.to_json)).to be_correctly_sent }
      it { expect(subject).to respond_with_status 201 } 
  end

  context "GET /api/v1/users : get all users" do
    it { expect(subject.get('/api/v1/users')).to be_correctly_sent }
    it { expect(subject).to respond_with_status 200 }
    it { expect(subject).to respond_a_collection_of_record }
    it { expect(subject).to respond_with_collection_size 1 }
  end

  context "DELETE /api/v1/user/:username : delete user by username" do
    it {
      expect(subject.delete('/api/v1/user/toto')).to be_correctly_sent }
      it { expect(subject).to respond_with_status 204 }
  end
end
