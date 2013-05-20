class PostsController < ApplicationController

  def create
    FetchCreatePost.perform_async
    head :ok
  end
  
  def index
    @posts = Post.all

    respond_to do |format|
      format.html
      format.js
    end
  end

end
