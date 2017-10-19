class CreatePackages < ActiveRecord::Migration[5.1]
  def change
    create_table :packages do |t|
      t.string :name, index: true
      t.string :version
      t.datetime :publication_date
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
