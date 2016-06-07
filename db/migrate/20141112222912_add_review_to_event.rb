class AddReviewToEvent < ActiveRecord::Migration
  def change
    add_reference :events, :review, index: true
  end
end
