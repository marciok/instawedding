class PostsController < ApplicationController
  before_filter :validate_instagram_token, only: [ :index ]
  after_filter :update_state, only: [ :last, :index ]

  def create
    # should i create here and fetch via worker ??
    FetchCreatePost.perform_async
    head :ok
  end

  def index
    @posts = Post.where(state: 'notviewed').asc(:created_at).limit('14')
    if @posts.empty?
      @posts = Post.all.asc(:created_at).limit('14')
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def last
    @post = Post.where(state: 'notviewed').asc(:created_at).first
    if @post
      respond_to do |format|
        format.json
      end
    else
      head :not_modified
    end
  end

  private

  def update_state
    if @posts or @post
      if @post
        @post.viewed
      else
        (@posts || []).map do |post|
          post.viewed
        end
      end
    end
  end

  def validate_instagram_token
    if params[:'hub.challenge']
       render text: params[:'hub.challenge']
    end
  end

end
