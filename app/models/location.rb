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

  before_validation :add_name


  def add_name
    self.name = "#{ self.teacher.first_name } #{ self.teacher.last_name } address"
  end


  def self.geocode_county( params, teacher_id )
    location_details = Geokit::Geocoders::GoogleGeocoder.geocode( "#{ params[:county] }, Ireland" )
    p location_details
    self.create(
      latitude: location_details.lat,
      longitude: location_details.lng,
      name: params[ :county ],
      teacher_id: teacher_id,
      address: "#{ params[:county] }, Ireland",
      county: params[ :county ]
    )
  end

  def self.manual_address( params, teacher_id )
    pp "#{ params[ :address ] }, #{ params[ :county ] } "
    location_details = Geokit::Geocoders::GoogleGeocoder.geocode( "#{ params[ :address ] }, #{ params[ :county ] } " )
    pp location_details
    self.create(
      latitude: location_details.lat, 
      longitude: location_details.lng,
      name: location_details.formatted_address,
      teacher_id: teacher_id,
      address: location_details.formatted_address,
      county: params[ :county ]
    )

  end

  
end
