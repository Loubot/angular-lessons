# == Schema Information
#
# Table name: qualifications
#
#  id         :integer          not null, primary key
#  title      :string
#  school     :string
#  start      :datetime
#  end_time   :datetime
#  teacher_id :integer
#  present    :binary
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class QualificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
