# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  teacher_id :integer
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Identity < ActiveRecord::Base
  belongs_to :teacher

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    pp auth
    identity = find_by(provider: auth['provider'], uid: auth['uid'])
    identity = create(uid: auth['uid'], provider: auth['provider']) if identity.nil?
    # identity.accesstoken = auth['credentials']['token']
    # identity.refreshtoken = auth['credentials']['refresh_token']
    # identity.name = auth['info']['name']
    # identity.email = auth['info']['email']
    # identity.nickname = aut['info']['name'].gsub(/\s+/, "")
    # identity.image = auth['info']['image']
    # identity.phone = auth['info']['phone']
    # identity.urls = (auth['info']['urls'] || "").to_json
    identity.save
    identity
  end
end
