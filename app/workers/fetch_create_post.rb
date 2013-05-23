class FetchCreatePost
  include Sidekiq::Worker


  def perform
    conn = Faraday.new do |faraday|
      faraday.adapter  Faraday.default_adapter
    end
    insta_post = Instagram.tag_recent_media(INSTA_TAG).last
    if insta_post and insta_post.caption
      resp = conn.get(insta_post.images.standard_resolution.url)
      if resp.status == 200
        post = Post.where(insta_id: insta_post.id).first_or_create!(
          insta_id: insta_post.id,
          author: insta_post.caption.from.username,
          text: insta_post.caption.text
        )
        post.image = Image.new(
          standart: insta_post.images.standard_resolution.url,
          thumbnail: insta_post.images.thumbnail.url,
          profile: insta_post.caption.from.profile_picture
        )
        post.save!
      end
    end
  end

end

