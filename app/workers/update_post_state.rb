class UpdatePostState
  include Sidekiq::Worker

  def perform(id)
    post = Post.find(id)
    post.state = 'visualized'
    post.save!
  end

end


