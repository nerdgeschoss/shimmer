# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :enforce_modal, only: [:modal]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_path, notice: "Post was successfully created."
    else
      render :new
    end
  end

  def modal
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end
end
