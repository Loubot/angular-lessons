# == Schema Information
#
# Table name: experiences
#
#  id          :integer          not null, primary key
#  description :string
#  teacher_id  :integer
#  start       :datetime
#  end_time    :datetime
#  present     :binary
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ExperienceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
