# frozen_string_literal: true

class PackagePeopleParser
  def initialize
    @authors = []
    @maintainers = []
  end

  def extract_people(text)
    _strip_roles(_sanitize(text)).split(/\,\s?/).map { |p| _extract_person(p) }
  end

  private

  def _extract_person(string)
    matched_email = /<(.+)>/.match(string)
    if matched_email
      matched_name = /([^<>]+)\s+/.match(string)
      { name: matched_name[1], email: matched_email[1] }
    else
      { name: string, email: nil }
    end
  end

  def _strip_roles(text)
    text.gsub(/\s?\[[^\]]+\]/, '')
  end

  def _sanitize(text)
    text.gsub(/\n\s+/, ' ').gsub(/\n+/, '')
  end
end
