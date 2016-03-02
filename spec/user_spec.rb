require_relative '../lib/Kii/kii_app'
require_relative '../lib/Kii/kii_user'
require_relative 'spec_helper'

describe KiiUserPersistance::KiiUser do

  before(:all) do
    VCR.turn_on!
    VCR.insert_cassette('user_specs', :record => :new_episodes)
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

  context 'User behaviour' do
    before(:all) do
      @user = @app.new_user({
                              login_name: 'your_username__2',
                              display_name: 'Your Name',
                              country: 'JP',   #<== country code must be capital ?
                              password: '123456',
                              email: 'your__2@mail.com',
                              phone_number: '09012341222'
                            })
      response = @user.signup # true
      response.code.should eq 201
    end

    it 'Should get user info' do
      @user.info.code.should eq 200
    end

    # Resend verification seems broken somehow
    # http://docs.kii.com/rest/apps-collection/application/user-collection/user-logged-in/e-mail-address/resend-verification/
    it 'Should send email verification code' do
#      @user.resend_email_verification.should eq 204
      # should send verification code to e-mail specified.
      # check your mail please ?
    end

    # http://docs.kii.com/rest/apps-collection/application/user-collection/user-logged-in/phone-number/resend-verification/
    it 'Should send sms verification code' do
#      @user.resend_sms_verification.should eq 204
      # should send verification code to phone number
      # check your sms please ?
    end

    it 'Should get access token' do
      @user.get_token.code.should eq 200
      @user.access_token.should_not be_nil
    end


    # you can't create a bucket directly.
    # create an object inside a bucket. bucket will be created automatically.
    #
    # it 'Should create bucket' do
    #   @bucket = @user.new_bucket({id: 'mybucket'})
    #   @bucket.create.code.should eq 204
    # end

    context 'User scope data object' do

      context 'default bucket' do

        before(:all) do 
          #  it 'Should create object' do
          @data = {'a' => 'b', 'c' => 'd'}
          @object = @user.new_object(@data)
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
          @bucket = 'some_bucket'
          @object = @user.buckets(@bucket).new_object(@data)
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

      after(:all) do
        @user.delete.code.should eq 204

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
end
