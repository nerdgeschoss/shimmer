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

  describe "#restore" do
    it "encodes size in generated ID and can restore it from there" do
      proxy = Shimmer::FileProxy.new(blob_id: blob.id, width: 100, height: 20)
      id = proxy.send(:id)
      variant = Shimmer::FileProxy.restore(id).variant

      expect(dimensions(variant.processed.image.blob)).to eq({width: 58, height: 20})
    end

    it "understands legacy resize string" do
      id = Shimmer::FileProxy.message_verifier.generate([blob.id, "100x20>"])
      variant = Shimmer::FileProxy.restore(id).variant

      expect(dimensions(variant.processed.image.blob)).to eq({width: 58, height: 20})
    end

    it "works if only passing width" do
      proxy = Shimmer::FileProxy.new(blob_id: blob.id, width: 100)
      id = proxy.send(:id)
      variant = Shimmer::FileProxy.restore(id).variant

      expect(dimensions(variant.processed.image.blob)).to eq({width: 100, height: 35})
    end

    it "works if only passing height" do
      proxy = Shimmer::FileProxy.new(blob_id: blob.id, height: 100)
      id = proxy.send(:id)
      variant = Shimmer::FileProxy.restore(id).variant

      expect(dimensions(variant.processed.image.blob)).to eq({width: 290, height: 100})
    end

    it "works if passing width or height as string" do
      proxy = Shimmer::FileProxy.new(blob_id: blob.id, width: "290", height: "100")
      id = proxy.send(:id)
      variant = Shimmer::FileProxy.restore(id).variant

      expect(dimensions(variant.processed.image.blob)).to eq({width: 290, height: 100})
    end

    it "converts the image to webp when passing webp as format" do
      proxy = Shimmer::FileProxy.new(blob_id: blob.id)
      id = proxy.send(:id)
      variant = Shimmer::FileProxy.restore(id, format: "webp").variant

      expect(variant.content_type).to eq("image/webp")
    end

    it "works if not resizing" do
      proxy = Shimmer::FileProxy.new(blob_id: blob.id)
      id = proxy.send(:id)
      original_blob = Shimmer::FileProxy.restore(id).variant

      expect(dimensions(original_blob)).to eq({width: 559, height: 193})
    end
  end

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
