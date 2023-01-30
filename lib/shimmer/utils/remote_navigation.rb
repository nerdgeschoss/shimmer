# frozen_string_literal: true

module Shimmer
  module RemoteNavigation
    extend ActiveSupport::Concern

    included do
      def ui
        @ui ||= RemoteNavigator.new(self)
      end

      def default_render
        return render_modal if shimmer_request?
        return super unless ui.updates?

        render turbo_stream: ui.queued_updates.join("\n")
      end

      helper_method :modal_path
      def modal_path(url, id: nil, size: nil, close: true)
        "javascript:ui.modal.open(#{{url: url, id: id, size: size, close: close}.to_json})"
      end

      helper_method :close_modal_path
      def close_modal_path(id = nil)
        if id.present?
          "javascript:ui.modal.close(#{{id: id}.to_json})"
        else
          "javascript:ui.modal.close()"
        end
      end

      helper_method :popover_path
      def popover_path(url, id: nil, selector: nil, placement: nil)
        "javascript:ui.popover.open(#{{url: url, id: id, selector: selector, placement: placement}.compact.to_json})"
      end

      def shimmer_request?
        request.headers["X-Shimmer"].present?
      end

      def render_modal
        enforce_modal
        render layout: false
      end

      def enforce_modal
        raise "trying to render a modal from a regular request" unless shimmer_request?
      end
    end
  end

  class RemoteNavigator
    delegate :polymorphic_path, to: :@controller

    def initialize(controller)
      @controller = controller
    end

    def queued_updates
      @queued_updates ||= []
    end

    def updates?
      queued_updates.any?
    end

    def run_javascript(script)
      queued_updates.push turbo_stream.append "shimmer", "<div class='hidden' data-controller='remote-navigation'>#{script}</div>"
    end

    def update(id, with: id, **locals)
      queued_updates.push turbo_stream.update(id, partial: with, locals: locals)
    end

    def replace(id, with: id, **locals)
      queued_updates.push turbo_stream.replace(id, partial: with, locals: locals)
    end

    def prepend(id, with:, **locals)
      queued_updates.push turbo_stream.prepend(id, partial: with, locals: locals)
    end

    def append(id, with:, **locals)
      queued_updates.push turbo_stream.append(id, partial: with, locals: locals)
    end

    def remove(id)
      queued_updates.push turbo_stream.remove(id)
    end

    def open_modal(url, id: nil, size: nil, close: true)
      run_javascript "ui.modal.open(#{{url: url, id: id, size: size, close: close}.to_json})"
    end

    def close_modal(id = nil)
      if id.present?
        run_javascript "ui.modal.close(#{{id: id}.to_json})"
      else
        run_javascript "ui.modal.close()"
      end
    end

    def open_popover(url, selector:, placement: nil)
      run_javascript "ui.popover.open(#{{url: url, selector: selector, placement: placement}.to_json})"
    end

    def close_popover
      run_javascript "ui.popover.close()"
    end

    def navigate_to(path)
      close_modal
      path = polymorphic_path(path) unless path.is_a?(String)
      run_javascript "Turbo.visit('#{path}')"
    end

    private

    def turbo_stream
      @controller.send(:turbo_stream)
    end
  end
end
