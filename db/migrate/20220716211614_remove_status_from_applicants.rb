class RemoveStatusFromApplicants < ActiveRecord::Migration[5.2]
  def change
    remove_column :applicants, :status, :string
  end
end
