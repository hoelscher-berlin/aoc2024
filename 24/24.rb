require 'set'
file = "input.txt"

sum1 = 0
sum2 = 0

pairs = []

wires = Hash.new
gates = Queue.new

x = []
y = []

mode = 0
File.open(file).each do |r|
    line = r.strip.split(": ")
    if line.length == 0
        mode = 1 
        next
    end

    if mode ==0
        val = line[1].to_i
        wires[line[0]] = val
        if line[0][0] == "x"
            x << val
        else
            y << val
        end
    else
        line = r.strip.split(" ")
        gate = {"type" => line[1], "w1" => line[0], "w2" => line[2], "output"=>line[4]}
        gates << gate
    end
end

x = x.reverse.join("").to_i(2)
y = y.reverse.join("").to_i(2)
expected = x+y

puts "x: #{x}"
puts "y: #{y}"
puts "expected result: #{expected}"



def calc(w1,w2,op)
    case op
    when "AND"
        w1 & w2
    when "OR"
        w1 | w2
    when "XOR"
        w1 ^ w2
    end
end


while !gates.empty?
    g = gates.deq
    if wires.key?(g["w1"]) && wires.key?(g["w2"])
        wires[g["output"]] = calc(wires[g["w1"]], wires[g["w2"]], g["type"])
    else
        gates.enq(g)
    end
end

sum1 = wires.select {|w,v| w[0] == "z"}.sort.reverse.map{|v| v[1]}.join.to_i(2)
puts sum1
puts (sum1 == expected)