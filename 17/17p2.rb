file = "input.txt"
sum1 = 0
sum2 = 0
$r = {}
$p = []
$pc = 0
$output = []

File.open(file).each do |line|
    l = line.strip.split(" ")
    if l.length == 3
        $r[l[1][0]] = l[2].to_i(8)
    end
    if l.length == 2
        $p = l[1].split(",").map{|i| i.to_i}
    end
end

#puts $r.inspect

def cop(op)
    case op
    when 0..3
        op
    when 4
        $r["A"]
    when 5
        $r["B"]
    when 6
        $r["C"]
    end
end

def exec(opcode, operand)
    case opcode
    when 0
        num = $r["A"]
        den = 2**cop(operand)
        res = num / (den*1.0)
        $r["A"] = res.to_int
        # truncate to int
    when 1
        n1 = $r["B"]
        n2 = operand
        $r["B"] = n1 ^ n2
    when 2
        $r["B"] = cop(operand) % 8
    when 3
        if $r["A"] != 0
            $pc = operand
            return
        end
    when 4
        $r["B"] = $r["B"] ^ $r["C"] 
    when 5
        $output.append(cop(operand)%8)
    when 6
        num = $r["A"]
        den = 2**cop(operand)
        res = num / (den*1.0)
        $r["B"] = res.to_int
    when 7
        num = $r["A"]
        den = 2**cop(operand)
        res = num / (den*1.0)
        $r["C"] = res.to_int
    end
    $pc += 2
end

def print_regs()
    puts "A: "+$r["A"].to_s
    puts "B: "+$r["B"].to_s
    puts "C: "+$r["C"].to_s
end

#puts $p.inspect

# found the solution to part 2 via writing input in octal
# backtracking: octal #n  of input only influences
# first n-1 digits of output

while($pc < $p.length) do
    #if $pc == 0 then puts end
    #puts "PC: "+$pc.to_s
    #puts "Executing OPCode "+$p[$pc].to_s+" with operand "+$p[$pc+1].to_s
    exec($p[$pc], $p[$pc+1])
    #print_regs()
end

str = ""
$output.each_with_index do |o,i|
    str += o.to_s
    if i!=$output.length-1
        str += ","
    end
end

puts str