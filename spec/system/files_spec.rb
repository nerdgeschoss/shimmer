# frozen_string_literal: true

require "system_helper"

RSpec.describe "Files" do
  fixtures :all

  it "doesn't blow up when invalid id is passed" do
    get file_path("invalid")

    expect(response).to have_http_status(:not_found)
  end

  it "doesn't blow up when file was deleted on S3" do
    id = Shimmer::FileProxy.message_verifier.generate(["123", nil])
    service_double = double
    allow(service_double).to receive(:download).with("key").and_raise(ActiveStorage::FileNotFoundError)
    deleted_file = instance_double(ActiveStorage::Blob, service: service_double, key: "key", representable?: true)
    allow(ActiveStorage::Blob).to receive(:find).with("123").and_return(deleted_file)

    get file_path(id)

    expect(response).to have_http_status(:not_found)
  end
end
