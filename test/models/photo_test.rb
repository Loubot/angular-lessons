# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  name           :string
#  imageable_id   :integer
#  imageable_type :string
#  avatar         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  avatar_tmp     :string
#

require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
