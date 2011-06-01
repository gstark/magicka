class Magicka
  def initialize(config_string)
    string_components = config_string.split

    @base_elements    = []
    @opposed_elements = []

    string_components.shift.to_i.times do
      base_element_triplet = string_components.shift.split(//)

      source  = base_element_triplet[0..1].sort
      replace = base_element_triplet[2]

      @base_elements << { :source => source, :replace => replace }
    end

    string_components.shift.to_i.times do
      @opposed_elements << string_components.shift.split(//)      
    end

    @elements = string_components.last.split(//)
  end

  def replacement_for_last_elements
    pair = [@new_elements[-2], @new_elements[-1]].compact.sort

    found_base_element = @base_elements.detect { |base_element| base_element[:source] == pair } || {}

    found_base_element[:replace]
  end

  def has_opposed_elements?
    @opposed_elements.any? { |opposed_element| @new_elements.include?(opposed_element[0]) && @new_elements.include?(opposed_element[1]) }
  end

  def process
    @new_elements = []

    @elements.each do |element|
      @new_elements << element
      pre_elements_length = @new_elements.length

      while replacement = replacement_for_last_elements
        @new_elements.pop(2)
        @new_elements << replacement
      end

      next if @new_elements.length < pre_elements_length

      @new_elements.clear if has_opposed_elements?
    end
  end

  def resulting_elements
    @new_elements = "[#{@new_elements.join(", ")}]"
    # @new_elements = ["[", @new_elements.join(", "), "]"].join
  end
end

# Main
number_of_test_cases = STDIN.gets.to_i
number_of_test_cases.times do |case_number|
  magicka = Magicka.new(gets)
  magicka.process

  puts "Case \##{case_number+1}: #{magicka.resulting_elements}"
end
