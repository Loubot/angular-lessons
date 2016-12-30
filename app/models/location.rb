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
#  county     :text
#

class Location < ActiveRecord::Base
  belongs_to :teacher, touch: true

  # has_many :prices, dependent: :destroy

  validates :teacher_id, :latitude, :longitude, presence: true

  validates :longitude, :latitude, numericality: { only_float: true }

  acts_as_mappable :default_units => :kms,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  after_save :add_name

  before_validation :check_if_only_county

  include LocationHelper


  def add_name
    self.name = "#{ self.teacher.get_full_name } address"
  end

  def check_if_only_county # if only county is present, need to add lat and long from LocationHelper
    if !( self.latitude.present? and self.longitude.present? and self.address.present? )
      counties = counties_with_coords()
      
      county = counties[ :"#{ self.county }"]
      p "This county here"
      pp county
      p county['latitude']
      self.latitude = county[:'latitude']
      self.longitude = county[:'longitude']
      self.address = self.county
      self.save!
    else

    end
  end




  def google_address( params )
    
    self.update_attributes(
      teacher_id: self.teacher.id,
      longitude:  params[ 'geometry' ][ 'location' ][ 'lng' ],
      latitude:   params[ 'geometry' ][ 'location' ][ 'lat' ],
      name:       "#{ self.teacher.get_full_name() } address",
      address:    params[ 'formatted_address' ],
      county:     params[ 'county' ]
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
