class Post
  include Mongoid::Document

  embeds_one :image

  field :author, type: String
  field :text, type: String
  field :insta_id, type: String
  field :created_at, type: Time

  validates :author, :text, :insta_id, :created_at, presence: true
  validates :insta_id, uniqueness: true

  state_machine :state, initial: :notviewed do
    event :viewed do
      transition notviewed: :visualized
    end

  end

end
