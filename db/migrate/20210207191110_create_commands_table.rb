class CreateCommandsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :commands do |t|
      t.string   :invocation
      t.string   :text
      t.string   :bot_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
