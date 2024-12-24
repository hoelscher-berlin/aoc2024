require 'rgl/adjacency'
require 'rgl/dot'
require 'set'
file = "input_4.txt"

sum1 = 0
sum2 = 0

pairs = []

wires = Hash.new
gates = Queue.new

x = []
y = []

graph = RGL::DirectedAdjacencyGraph.new
j=0
mode = 0
File.open(file).each do |r|
    line = r.strip.split(": ")
    if line.length == 0
        mode = 1 
        next
    end

    if mode == 0
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
        graph.add_edge(line[0],line[1]+j.to_s)
        graph.add_edge(line[2],line[1]+j.to_s)
        graph.add_edge(line[1]+j.to_s,line[4])
        j+=1
    end
end
#=begin
x = x.reverse.join("").to_i(2)
y = y.reverse.join("").to_i(2)
expected = x+y
#=end

# look at it and fix it :)
#graph.write_to_graphic_file('jpg')

#=begin
max_45_bit_value = (1 << 45) - 1  # 2^45 - 1
# Generate two random 45-bit numbers
xold = Random.rand(0..max_45_bit_value)
yold = Random.rand(0..max_45_bit_value)

expected = xold+yold

x = xold.to_s(2).split("").reverse
y = yold.to_s(2).split("").reverse

45.times do |i|
    nr = i.to_s
    nr = "0"+i.to_s if i < 10
    if i<x.length
        wires["x"+nr] = x[i].to_i
    else
        wires["x"+nr] = 0
    end

    if i<y.length
        wires["y"+nr] = y[i].to_i
    else
        wires["y"+nr] = 0
    end
end
#=end

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
puts expected == sum1