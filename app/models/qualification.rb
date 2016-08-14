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

class Qualification < ActiveRecord::Base
	belongs_to :teacher, touch: true
	# validates :start, :end_time, date: true
	# validates :start, date: { before: :end_time, message: 'must be after end time' }
	validates :title, :school, :teacher_id, presence: true #:start, :end_time,

	# before_validation :addTime

	# def addTime
	# 	if self.present == '1'
	# 		self.end_time = Time.now()
	# 	end
	# end
end
