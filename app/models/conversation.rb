# == Schema Information
#
# Table name: conversations
#
#  id            :integer          not null, primary key
#  teacher_email :string
#  student_email :string
#  teacher_name  :string
#  student_name  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Conversation < ActiveRecord::Base

  has_many :messages, dependent: :destroy
end
