# == Schema Information
#
# Table name: charges
#
#  id         :integer          not null, primary key
#  teacher_id :integer
#  mins       :integer
#  price      :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ChargeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
