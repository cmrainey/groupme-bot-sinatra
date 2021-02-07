class CreateScannablesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :scannables do |t|
      t.string   :bot_id
      t.string   :group_id
      t.string   :text
      t.string   :response
      t.string   :command_invocation
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
