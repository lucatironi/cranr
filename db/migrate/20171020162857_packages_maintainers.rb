# frozen_string_literal: true

class PackagesMaintainers < ActiveRecord::Migration[5.1]
  def change
    create_table :packages_maintainers, id: false do |t|
      t.belongs_to :package, index: true
      t.belongs_to :person, index: true
    end
  end
end
