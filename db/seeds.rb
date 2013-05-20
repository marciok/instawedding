# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
insta_posts = Instagram.tag_recent_media(INSTA_TAG)
insta_posts.map do |insta_post|
  if insta_post and insta_post.caption
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
