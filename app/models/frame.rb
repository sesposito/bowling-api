class Frame < ApplicationRecord
  belongs_to :game
  has_one :parent_frame, foreign_key: 'frame_id', class_name: 'Frame'
  has_many :rolls
end
