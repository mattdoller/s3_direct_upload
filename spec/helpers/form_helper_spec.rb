require "spec_helper"

describe S3DirectUpload::UploadHelper::S3Uploader do
  describe "policy_data" do
    describe "starts-with $key" do
      it "is configurable with the key_starts_with option" do
        puts "S3DirectUpload: #{S3DirectUpload.config.methods}"
        key_starts_with = "uploads/"
        s3_uploader = S3DirectUpload::UploadHelper::S3Uploader.new(
          key_starts_with: key_starts_with
        )

        expect(s3_uploader.policy_data[:conditions]).to include(
          ["starts-with", "$key", key_starts_with]
        )
      end

      it "defaults to 'uploads/'" do
        s3_uploader = S3DirectUpload::UploadHelper::S3Uploader.new({})

        expect(s3_uploader.policy_data[:conditions]).to include(
          ["starts-with", "$key", "uploads/"]
        )
      end
    end

    describe "starts-with $content-type" do
      it "is configurable with the content_type_starts_with option" do
        content_type_starts_with = "image/"

        s3_uploader = S3DirectUpload::UploadHelper::S3Uploader.new(
          content_type_starts_with: content_type_starts_with
        )

        expect(s3_uploader.policy_data[:conditions]).to include(
          ["starts-with", "$content-type", content_type_starts_with]
        )
      end

      it "is defaults to an empty string" do
        s3_uploader = S3DirectUpload::UploadHelper::S3Uploader.new({})

        expect(s3_uploader.policy_data[:conditions]).to include(
          ["starts-with", "$content-type", ""]
        )
      end
    end

    describe "#policy_data" do
      it "includes server side encryption" do
        s3_uploader = S3DirectUpload::UploadHelper::S3Uploader.new(
          server_side_encryption: "AES256"
        )

        hash = s3_uploader.policy_data[:conditions].select do |condition|
          condition.class == Hash
        end.select do |hash|
          hash.key?("x-amz-server-side-encryption")
        end

        expect(hash).to include({
          "x-amz-server-side-encryption" => "AES256"
        })
      end
    end
  end
end
