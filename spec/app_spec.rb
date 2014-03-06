require_relative '../lib/Kii/kii_app'

describe KiiApp do

  before(:all) do
    @app = KiiApp.new
    @app.get_admin_token
  end

  it 'Should get token' do
#    @app.app_admin_token.should be_nil
    response = @app.get_admin_token
    response.code.should eq 200
    @app.access_token.should_not be_nil
  end


  context 'App scope data object - default bucket' do
    before(:all) do 
#  it 'Should create object' do
      @data = {'a' => 'b', 'c' => 'd'}
      @object = @app.new_object(@data)
      @object.create.code.should eq 201
    end

    it 'Should get object' do
      @object.get.code.should eq 200
      @object.data.should == @data
    end

    it 'Should update object' do
      data = {'arda' => 'rulezz'}
      @object.data = data
      @object.update.code.should eq 200
      @object.get
      @object.data.should == data
    end

    it 'Should delete object' do
      @object.delete.code.should eq 204
      begin
        @object.get
      rescue Exception => e
        puts e.message
        e.message.should eq "404 Resource Not Found"
      end
    end
  end


  context 'App scope data object - custom bucket' do
    before(:all) do 
#  it 'Should create object' do
      @data = {'a' => 'b', 'c' => 'd'}
      @bucket = 'some_bucket'
      @object = @app.buckets(@bucket).new_object(@data)
      @object.create.code.should eq 201
    end

    it 'Should get object' do
      @object.get.code.should eq 200
      @object.data.should == @data
    end

    it 'Should update object' do
      data = {'arda' => 'rulezz'}
      @object.data = data
      @object.update.code.should eq 200
      @object.get
      @object.data.should == data
    end

    it 'Should delete object' do
      @object.delete.code.should eq 204
      begin
        @object.get
      rescue Exception => e
        puts e.message
        e.message.should eq "404 Resource Not Found"
      end
    end
  end


end
