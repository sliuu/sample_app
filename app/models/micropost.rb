class Micropost < ActiveRecord::Base
  # this line created automatically
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  # allowing users to upload images
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # singular 'validate'! result of a custom validation
  validate  :picture_size


  # file size validation does not correspond to a built-in Rails validation
  # method must be created by hand
  private

      # Validates the size of an uploaded picture.
      def picture_size
        if picture.size > 5.megabytes
          errors.add(:picture, "should be less than 5MB")
        end
      end

end
