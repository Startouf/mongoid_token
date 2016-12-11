# proposed pattern options
# %a - lowercase alphanumeric character
# %A - uppercase alphanumeric character
# %c - lowercase character
# %C - uppercase character
# %d - digit
# %D - non-zero digit / no-leading zero digit if longer than 1
# %s - alphanumeric character
# %w - upper and lower alpha character
# %p - URL-safe punctuation
#
# Any pattern can be followed by a number, representing how many of that type to generate

module Mongoid
  module Token
    module Generator
      REPLACE_PATTERN = /%((?<character>[aAcCdDhHpsw]{1})(?<length>\d+(,\d+)?)?)/

      def self.generate(pattern)
        pattern.gsub REPLACE_PATTERN do |match|
          match_data = $~
          type = match_data[:character]
          length = [match_data[:length].to_i, 1].max

          case type
          when 'a'
            alphanumeric(length).downcase
          when 'A'
            alphanumeric(length).upcase
          when 'c'
            down_character(length)
          when 'C'
            up_character(length)
          when 'd'
            digits(length)
          when 'D'
            integer(length)
          when 'h'
            digits(length, 16)
          when 'H'
            integer(length, 16)
          when 's'
            alphanumeric(length)
          when 'w'
            alpha(length)
          when 'p'
            '-'
          end
        end
      end

      class << self
        private

        def rand_string_from_chars(chars, length = 1)
          Array.new(length).map { chars.sample }.join
        end

        def down_character(length = 1)
          rand_string_from_chars ('a'..'z').to_a, length
        end

        def up_character(length = 1)
          rand_string_from_chars ('A'..'Z').to_a, length
        end

        def integer(length = 1, base = 10)
          (rand(base**length - base**(length - 1)) + base**(length - 1)).to_s(base)
        end

        def digits(length = 1, base = 10)
          rand(base**length).to_s(base).rjust(length, '0')
        end

        def alpha(length = 1)
          rand_string_from_chars (('A'..'Z').to_a + ('a'..'z').to_a), length
        end

        def alphanumeric(length = 1)
          (1..length).collect { (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61))).chr }.join
        end

        def punctuation(length = 1)
          rand_string_from_chars ['.', '-', '_', '=', '+', '$'], length
        end
      end
    end
  end
end
