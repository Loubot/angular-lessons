# == Schema Information
#
# Table name: conversations
#
#  id            :integer          not null, primary key
#  teacher_email :string
#  student_email :string
#  teacher_name  :string
#  student_name  :string
#  random        :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
