class Post
  include Mongoid::Document

  embeds_one :image

  field :author, type: String
  field :text, type: String

  validates :author, :text, presence: true

end
