# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  message         :text
#  sender_email    :string
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
