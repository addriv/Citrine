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
    infix.each do |el|
      if el == "("
        stack << el
        @converted_units += el
      elsif el == ")"
        while (popped = stack.pop) && popped != "("
          @postfix_factors << popped
        end
        @converted_units += el
      elsif ["/", "*"].include?(el)
        while (last = stack.last) && last != "("
          @postfix_factors << stack.pop
        end
        stack << el
        @converted_units += el
      else
        @postfix_factors << SiConversion.convert_unit(el, :factor)
        @converted_units += SiConversion.convert_unit(el, :unit)
      end
    end
    @postfix_factors << stack.pop while !stack.empty?
  end

  def convert
    i = 0
    calc = @postfix_factors.dup
    while calc.length > 1
      el = calc[i]
      if ["/", "*"].include?(el)
        evaluated = calc[i-2].send(el.to_sym, calc[i-1].to_f)
        calc = calc[0...i-2] + [evaluated] + calc[i+1..-1]
        i -= 1
      else
        i += 1
      end
    end
    calc[0].round(14)
  end
end

