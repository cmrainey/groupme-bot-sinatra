class CreateBotsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :bots do |t|
      t.string   :bot_id
      t.string   :group_id
      t.string   :group_name
      t.boolean  :disable_scanner
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_column :bots, :banned_functions, :string, array: true, default: []
  end
end
