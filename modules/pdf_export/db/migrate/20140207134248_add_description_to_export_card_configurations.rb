

class AddDescriptionToExportCardConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :export_card_configurations, :description, :text
  end
end
