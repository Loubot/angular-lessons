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
#  created_at :datetime
#  updated_at :datetime
#  present    :binary
#

class Qualification < ActiveRecord::Base
	belongs_to :teacher, touch: true
	validates :start, :end_time, date: true
	validates :start, date: { before: :end_time, message: 'must be after end time' }
	validates :title, :school, :start, :end_time, :teacher_id, presence: true

	before_validation :addTime

	def addTime
		if self.present == '1'
			self.end_time = Time.now()
		end
	end
end
