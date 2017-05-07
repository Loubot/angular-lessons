# == Schema Information
#
# Table name: conversations
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id1              :integer
#  user_id2              :integer
#  user_email1           :string
#  user_email2           :string
#  user_name1            :string
#  user_name2            :string
#  user_id1_notification :integer          default(0)
#  user_id2_notification :integer          default(0)
#

require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
