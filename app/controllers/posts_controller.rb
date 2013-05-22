class PostsController < ApplicationController

  def create
    # should i create here and fetch via worker ??
    FetchCreatePost.perform_async
    head :ok
  end

  def index
    @posts = Post.all.limit('14')

    respond_to do |format|
      format.html
      format.js
    end
  end

  def latest
    @posts = Post.where(state: 'notviewed').asc(:created_at).limit(3)
    @posts.map do |post|
      UpdatePostState.perform_async(post.id)
    end
    respond_to do |format|
      format.json
    end
  end

end
