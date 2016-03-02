require_relative '../lib/Kii/kii_app'
require_relative '../lib/Kii/kii_group'
require_relative 'spec_helper'

describe KiiGroupPersistance::KiiGroup do

  before(:all) do
    VCR.turn_on!
    VCR.insert_cassette('group_specs', :record => :new_episodes)
    @app = KiiApp.new
    @app.get_admin_token
  end

  after(:all) do
    VCR.eject_cassette
    VCR.turn_off!
  end

  it 'Should get token' do
    response = @app.get_admin_token
    response.code.should eq 200
    @app.access_token.should_not be_nil
  end

  context 'Group behaviour' do
    before(:all) do
      @user = @app.new_user({
                              login_name: 'your_username__3',
                              display_name: 'Your Name',
                              country: 'JP',   #<== country code must be capital ?
                              password: '123456',
                              email: 'your__3@mail.com',
                              phone_number: '09012341223'
                            })
      response = @user.signup # true
      response.code.should eq 201

      @user2 = @app.new_user({
                              login_name: 'your_username__4',
                              display_name: 'Your Name',
                              country: 'JP',   #<== country code must be capital ?
                              password: '123456',
                              email: 'your__4@mail.com',
                              phone_number: '09012341224'
                            })
      response = @user2.signup # true
      response.code.should eq 201

      @group = @user.new_group 'test_group', [@user2.id]
    end

    it "should create group" do
      @group.create.code.should eq 201
      @group.id.should_not be_nil
    end

    context 'Group scope data object' do

      context 'default bucket' do

        before(:all) do
          #  it 'Should create object' do
          @data = {'a' => 'b', 'c' => 'd'}
          @object = @group.new_object(@data)
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


      context 'custom bucket' do

        before(:all) do 
          #  it 'Should create object' do
          @data = {'a' => 'b', 'c' => 'd'}
          @bucket = 'group_bucket'
          @object = @group.buckets(@bucket).new_object(@data)
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
    
    context 'Group access' do

      # check if user2 can acces group scope object.
    end


    after(:all) do
      @user.delete.code.should eq 204
      @user2.delete.code.should eq 204
      begin
        response = @user.info
      rescue Exception => e
        puts e.message
        e.message.should eq "404 Resource Not Found"
        #        puts e
      end

    end

  end

end

