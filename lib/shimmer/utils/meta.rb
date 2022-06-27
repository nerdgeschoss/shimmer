# frozen_string_literal: true

module Shimmer
  class Meta
    class_attribute :app_name
    attr_accessor :title, :description, :image, :canonical

    def tags
      tags = []
      title = self.title.present? ? "#{self.title} | #{app_name}" : app_name
      tags.push(type: :title, value: title)
      tags.push(property: "og:title", content: title)
      if description.present?
        tags.push(name: :description, content: description)
        tags.push(property: "og:description", content: description)
      end
      if image.present?
        tags.push(property: "og:image", content: image)
      end
      if canonical.present?
        tags.push(type: :link, rel: :canonical, href: canonical)
        tags.push(property: "og:url", content: canonical)
      end
      tags.push(property: "og:type", content: :website)
      tags.push(property: "og:locale", content: I18n.locale)
      tags.push(name: "twitter:card", content: :summary_large_image)
      tags
    end
  end
end
