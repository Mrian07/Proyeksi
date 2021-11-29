

class AddActiveToExportCardConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :export_card_configurations, :active, :boolean, default: true
  end
end
