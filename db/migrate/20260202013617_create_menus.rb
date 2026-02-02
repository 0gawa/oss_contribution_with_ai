class CreateMenus < ActiveRecord::Migration[7.2]
  def change
    create_table :menus do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.string :image_url
      t.boolean :is_available, null: false, default: true
      t.string :category

      t.timestamps
    end

    add_index :menus, :is_available
    add_index :menus, :category
  end
end
