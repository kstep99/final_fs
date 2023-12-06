class AddPendingToStatuses < ActiveRecord::Migration[7.0]
  def up
    Status.create(name: "Pending") unless Status.exists?(name: "Pending")
  end

  def down
    pending_status = Status.find_by(name: "Pending")
    pending_status.destroy if pending_status
  end
end