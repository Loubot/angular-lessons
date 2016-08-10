# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  teacher_id :integer
#  latitude   :float
#  longitude  :float
#  name       :string
#  address    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Location < ActiveRecord::Base
  belongs_to :teacher, touch: true

  # has_many :prices, dependent: :destroy

  validates :teacher_id, :latitude, :longitude, :name, presence: true

  validates :longitude, :latitude, numericality: { only_float: true }

  acts_as_mappable :default_units => :kms,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  
end
