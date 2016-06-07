class AddEventToReview < ActiveRecord::Migration
  def change
    add_reference :reviews, :event, index: true
  end
end
