# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @posts = Post.all
  end
end
