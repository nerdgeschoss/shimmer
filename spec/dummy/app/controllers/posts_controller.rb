# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @posts = Post.all
    puts "🔵  index"
  end

  def new
    @post = Post.new
  end

  def create
  end
end
