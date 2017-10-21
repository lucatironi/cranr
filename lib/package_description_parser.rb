# frozen_string_literal: true

class PackageDescriptionParser
  # Adapted from: https://stackoverflow.com/a/11090412
  # (?<=                Lookbehind assertion.
  #     ^                   Start at the beginning of the string,
  #     |                   or,
  #     [\r\n]              a new line.
  # )
  # (                   Capture group 1, the "key".
  #     [A-Z][^:]*          Capital letter followed as many non-colon
  #                         characters as possible.
  # )
  # :                   The colon character.
  # \s                  Whitespace
  # (                   Capture group 2, the "value".
  #     [^\r\n]*            All characters (i.e. non-newline characters) on the
  #                         same line belongs to the "value," so take them all.

  #     (?:             Non-capture group.

  #         [\r\n]+         Having already taken everything up to a newline
  #                         character, take the newline character(s) now.

  #         (?!             Negative lookahead assertion.
  #             [^A-Z].*:       If this next line contains a capital letter,
  #                             followed by a string of anything then a colon,
  #                             then it is a new key/value pair, so we do not
  #                             want to match this case.
  #         )
  #         .*              Providing this isn't the case though, take the line!

  #     )*              And keep taking lines as long as we don't find a
  #                     key/value pair.
  # )
  REGEX = /(?<=^|[\r\n])([A-Z][^:]*):\s([^\r\n]*(?:[\r\n]+(?![A-Z].*:).*)*)/

  def initialize
    @data = {}
  end

  def extract(text)
    @data = text.scan(REGEX).each_with_object({}) do |kv_pair, h|
      h[kv_pair[0]] = kv_pair[1].gsub(/\n\s+/, ' ').delete("\n")
    end
    @data
  end
end
