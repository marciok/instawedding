# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
conn = Faraday.new do |faraday|
  faraday.adapter  Faraday.default_adapter
end

# ************* EXTRA ****************
hangover_posts = Instagram.tag_recent_media('hangoverpupo',max_id: '1360488794583')
hangover_posts.push(*Instagram.tag_recent_media('hangoverpupo'))
# ************************************

insta_posts = Instagram.tag_recent_media(INSTA_TAG)
old_posts = Instagram.tag_recent_media(INSTA_TAG,max_id: '1369292953726')
insta_posts = insta_posts.push(*old_posts)
insta_posts = insta_posts.push(*hangover_posts)

insta_posts.map do |insta_post|
  if insta_post and insta_post.caption
    resp = conn.get(insta_post.images.standard_resolution.url)
    if resp.status == 200
      post = Post.where(insta_id: insta_post.id).first_or_create!(
        insta_id: insta_post.id,
        author: insta_post.caption.from.username,
        text: insta_post.caption.text,
        created_at: Time.at(insta_post.created_time.to_i).utc
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
