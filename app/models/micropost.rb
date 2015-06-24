class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, ::PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        error.add(:picture, "Not sure what you're trying to upload but it's huge!!! Try something less than 5MB")
      end
    end
end
