class PostsController < ApplicationController
  before_filter :validate_instagram_token, only: [ :index ]

  def create
    # should i create here and fetch via worker ??
    FetchCreatePost.perform_async
    head :ok
  end

  def index
    @posts = Post.all.limit('14')
    puts @posts.count

    respond_to do |format|
      format.html
      format.js
    end
  end

  def last
    @post = Post.where(state: 'notviewed').asc(:created_at).first
    if @post
      @post.state = 'visualized'
      @post.save!

      respond_to do |format|
        format.json
      end
    else
      head :not_modified
    end
  end

  private

  def validate_instagram_token
    if params[:'hub.challenge']
       render text: params[:'hub.challenge']
    end
  end

end
