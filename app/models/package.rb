# frozen_string_literal: true

class Package < ApplicationRecord
  has_and_belongs_to_many :authors,
                          class_name: 'Person', join_table: :packages_authors
  has_and_belongs_to_many :maintainers,
                          class_name: 'Person', join_table: :packages_maintainers
end
