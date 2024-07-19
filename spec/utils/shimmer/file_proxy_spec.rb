# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shimmer::FileProxy do
  let(:blob) {
    ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join("spec/fixtures/files/nerdgeschoss.jpg")),
      filename: "example",
      content_type: "image/jpeg"
    )
  }

  describe "#variant" do
    it "returns the blob if no resize requested" do
      variant = Shimmer::FileProxy.new(blob_id: blob.id).variant

      expect(variant).to eq(blob)
    end

    context "when requesting different size" do
      it "scales the image down" do
        variant = Shimmer::FileProxy.new(blob_id: blob.id, width: 100, height: 200).variant

        expect(dimensions(variant.processed.image.blob)).to eq({width: 100, height: 35})
      end

      it "does not scale the image up" do
        variant = Shimmer::FileProxy.new(blob_id: blob.id, width: 1000).variant

        original_dimensions = dimensions(blob)
        new_dimensions = dimensions(variant.processed.image.blob)

        expect(new_dimensions).to eq(original_dimensions)
      end
    end
  end

  def dimensions(blob)
    ActiveStorage::Analyzer::ImageAnalyzer::Vips.new(blob).metadata
  end
end
