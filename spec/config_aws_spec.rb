require 'spec_helper'

describe S3DirectUpload::Config do
  around do |example|
    env_vars = {
      AWS_ACCESS_KEY_ID: 'access-key-id',
      AWS_SECRET_ACCESS_KEY: 'secret-access-key',
    }

    ClimateControl.modify(env_vars) do
      example.run
      S3DirectUpload.config.credentials_callback = nil
    end
  end

  describe '#access_key_id' do
    context 'when the credentials_callback is nil' do
      it 'returns the ENV["AWS_ACCESS_KEY_ID"] value' do
        S3DirectUpload.config.access_key_id.should == 'access-key-id'
      end
    end

    context 'when the credentials_callback is defined' do
      it 'invokes the callback and returns the value' do
        credentials = OpenStruct.new(access_key_id: 'callback-access-key-id')

        S3DirectUpload.config.credentials_callback = -> () { credentials }

        S3DirectUpload.config.access_key_id.should == 'callback-access-key-id'
      end
    end
  end

  describe '#secret_access_key' do
    context 'when the credentials_callback is nil' do
      it 'returns the ENV["AWS_SECRET_ACCESS_KEY"] value' do
        S3DirectUpload.config.secret_access_key.should == 'secret-access-key'
      end
    end

    context 'when the credentials_callback is defined' do
      it 'invokes the callback and returns the value' do
        credentials = OpenStruct.new(secret_access_key: 'callback-secret-access-key')

        S3DirectUpload.config.credentials_callback = -> () { credentials }

        S3DirectUpload.config.secret_access_key.should == 'callback-secret-access-key'
      end
    end
  end
end
