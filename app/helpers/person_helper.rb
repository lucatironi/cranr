# frozen_string_literal: true

require 'cran_uri_helper'

module PersonHelper
  def format_person(person)
    ret = person.name
    ret += " (#{person.email})" if person.email
    ret
  end
end
