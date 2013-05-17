class Image 
  include Mongoid::Document

  embedded_in :post

  field :standart, type: String
  field :thumbnail, type: String
  field :profile, type: String

  validates :standart, :thumbnail, :profile, presence: true

end
