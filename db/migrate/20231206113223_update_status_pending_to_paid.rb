class UpdateStatusPendingToPaid < ActiveRecord::Migration[7.0]
  def up
    status = Status.find_by(name: "Pending")
    status.update(name: "Paid") if status
  end

  def down
    status = Status.find_by(name: "Paid")
    status.update(name: "Pending") if status
  end
end