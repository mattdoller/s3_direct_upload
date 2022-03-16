require "singleton"

module S3DirectUpload
  class Config
    include Singleton

    attr_accessor(
      :credentials_callback,
      :bucket,
      :prefix_to_clean,
      :region,
      :url
    )

    def access_key_id
      if credentials_callback
        credentials_callback.call.access_key_id
      else
        ENV["AWS_ACCESS_KEY_ID"]
      end
    end

    def secret_access_key
      if credentials_callback
        credentials_callback.call.secret_access_key
      else
        ENV["AWS_SECRET_ACCESS_KEY"]
      end
    end
  end

  def self.config
    if block_given?
      yield Config.instance
    end

    Config.instance
  end
end
