class AddAppStatustoApplicant < ActiveRecord::Migration[5.2]
  def change
    add_column :applicants, :app_status, :string, default: 'In Progress'
  end
end
