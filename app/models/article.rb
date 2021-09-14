class Article < ApplicationRecord
  include Rails.application.routes.url_helpers

  mount_uploader :image, ImageUploader


  belongs_to :user
end



'''
def get_image_url
  url_for(self.image)
end
'''
