class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string :image
      t.string :name
      t.integer :people_quantity
      t.text :ingredients, array: true, default: []
      t.text :tags, array: true, default: []
    end
  end
end
