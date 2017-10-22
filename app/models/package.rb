# frozen_string_literal: true

class Package < ApplicationRecord
  has_and_belongs_to_many :authors,
                          class_name: 'Person', join_table: :packages_authors
  has_and_belongs_to_many :maintainers,
                          class_name: 'Person', join_table: :packages_maintainers

  def self.latest
    Package.find_by_sql(
      <<-SQL.strip_heredoc
        SELECT p1.*
        FROM packages p1 INNER JOIN
        (
          SELECT p.name, MAX(p.created_at) AS latest
          FROM packages p
          GROUP BY p.name
        ) p2
        ON p1.name = p2.name AND p1.created_at = p2.latest
      SQL
    )
  end
end
