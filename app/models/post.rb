class Post
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  embeds_one :image

  field :author, type: String
  field :text, type: String
  field :insta_id, type: String

  validates :author, :text, :insta_id, presence: true

  state_machine :state, initial: :notviewed do
    event :viewed do
      transition notviewed: :visualized
    end

  end

end
