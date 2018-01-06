class SiConversion
  attr_reader :converted_units, :multiplication_factor

  def initialize(input_units)
    @input_units = input_units
    @postfix_factors = []
    @converted_units = ""
    parse_input
    @multiplication_factor = convert
  end

  def self.convert_unit(unit, type)
    conversion_table = {
      "minute" => { factor: 60, unit: "s"},
      "min" => { factor: 60, unit: "s"},
      "hour" => { factor: 3600, unit: "s"},
      "h" => { factor: 3600, unit: "s"},
      "day" => { factor: 86400, unit: "s"},
      "d" => { factor: 86400, unit: "s"},
      "degree" => { factor: (Math::PI/180), unit: "rad"},
      "°" => { factor: (Math::PI/180), unit: "rad"},
      "'" => { factor: (Math::PI/10800), unit: "rad"},
      "‘" => { factor: (Math::PI/10800), unit: "rad"},
      "second" => { factor: (Math::PI/64800), unit: "rad"},
      '"' => { factor: (Math::PI/64800), unit: "rad"},
      "“" => { factor: (Math::PI/64800), unit: "rad"},
      "hectare" => { factor: 10000, unit: "m^2"},
      "ha" => { factor: 10000, unit: "m^2"},
      "litre" => { factor: 0.001, unit: "m^3"},
      "L" => { factor: 0.001, unit: "m^3"},
      "tonne" => { factor: 10**3, unit: "kg"},
      "t" => { factor: 10**3, unit: "kg"}
    }

    conversion_table[unit][type]
  end
  
  private

  def parse_input
    stack = []
    
    infix = @input_units.scan(/\W|[\w.]+/)
    infix.each do |input|
      if input == "("
        stack << input
        @converted_units += input
      elsif input == ")"
        while (popped = stack.pop) && popped != "("
          @postfix_factors << popped
        end
        @converted_units += input
      elsif ["/", "*"].include?(input)
        while (last = stack.last) && last != "("
          @postfix_factors << stack.pop
        end
        stack << input
        @converted_units += input
      else
        @postfix_factors << SiConversion.convert_unit(input, :factor)
        @converted_units += SiConversion.convert_unit(input, :unit)
      end
    end
    @postfix_factors << stack.pop while !stack.empty?
  end

  def convert
    i = 0
    calculation = @postfix_factors.dup
    while calculation.length > 1
      input = calculation[i]
      if ["/", "*"].include?(input)
        evaluated = calculation[i-2].send(input.to_sym, calculation[i-1].to_f)
        calculation = calculation[0...i-2] + [evaluated] + calculation[i+1..-1]
        i -= 1
      else
        i += 1
      end
    end
    calculation[0].round(14)
  end
end

