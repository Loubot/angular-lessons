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
#  created_at :datetime
#  updated_at :datetime
#

class Location < ActiveRecord::Base
  belongs_to :teacher, touch: true

  # has_many :prices, dependent: :destroy

  validates :teacher_id, :latitude, :longitude, :name, presence: true

  validates :longitude, :latitude, numericality: { only_float: true }

  # geocoded_by :full_street_address


  # after_create :geocode
  # reverse_geocoded_by :latitude, :longitude
  # before_create :reverse_geocode  # auto-fetch address

  def full_street_address
    self.address
  end
end