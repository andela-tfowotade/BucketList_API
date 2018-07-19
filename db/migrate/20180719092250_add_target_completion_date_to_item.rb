class AddTargetCompletionDateToItem < ActiveRecord::Migration
  def change
    add_column :items, :target_completion_date, :date
  end
end
