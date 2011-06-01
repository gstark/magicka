class Magicka
  def initialize(config_string)
    string_components = config_string.split

    @base_elements    = []
    @opposed_elements = []

    string_components.shift.to_i.times do
      base_element_triplet = string_components.shift

      source  = base_element_triplet[0..1].split(//).sort
      replace = base_element_triplet[2..2]

      @base_elements << { :source => source, :replace => replace }
    end

    string_components.shift.to_i.times do
      @opposed_elements << string_components.shift.split(//)      
    end

    # We don't need the number of elements
    string_components.shift

    @elements = string_components.first.split(//)
  end

  def replacement_for_last_pair
    pair = [@new_elements[-2],@new_elements[-1]].map(&:to_s).sort

    found_base_element = @base_elements.detect { |base_element| base_element[:source] == pair } || {}

    found_base_element[:replace]
  end

  def has_opposed_elements?
    @opposed_elements.any? do |opposed_element|
      elements = @new_elements.dup

      elements.delete(opposed_element[0]) && elements.delete(opposed_element[1])
    end
  end

  def process
    @new_elements = []

    @elements.each do |element|
      @new_elements << element

      replaced = false
      while replacement = replacement_for_last_pair
        @new_elements.pop(2)
        @new_elements << replacement
        replaced = true
      end

      next if replaced

      @new_elements.clear if has_opposed_elements?
    end
  end

  def resulting_elements
    @new_elements = ["[", @new_elements.join(", "), "]"].join
  end
end

# Main
number_of_test_cases = STDIN.gets.to_i
number_of_test_cases.times do |case_number|
  magicka = Magicka.new(gets)
  magicka.process

  puts "Case \##{case_number+1}: #{magicka.resulting_elements}"
end
