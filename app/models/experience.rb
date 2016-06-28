# == Schema Information
#
# Table name: experiences
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  teacher_id  :integer
#  start       :datetime
#  end_time    :datetime
#  present     :binary
#  created_at  :datetime
#  updated_at  :datetime
#

class Experience < ActiveRecord::Base
	belongs_to :teacher, touch: true

	# validates :title, :description, :teacher_id, :start, presence: true

	# validates :start, :end_time, date: true

	# validates :start, date: { before: :end_time, message: 'must be after end time' }

	before_save :addTime


	def addTime
		if self.present == '1'
			self.end_time = self.start + 5.years
		end
	end
end
