sum1 = 0
sum2 = 0

files = ["example.txt", "input.txt"]
file = files[1]

# DON'T USE HASHMAP >:(
calcs = []

File.open(file).each do |line|
    l = line.strip.split(": ")
    calcs << [l[0].to_i, l[1].split(" ").map {|v| v.to_i}]
end

def calc(k, nrs, curr_result, results, part2=false)
    if nrs.length == 1
        results << curr_result
        return
    end
    if curr_result > k
        return
    end
    calc(k, nrs.drop(1), curr_result*nrs[1], results,part2)
    calc(k, nrs.drop(1), curr_result+nrs[1], results,part2)
    if part2
        calc(k, nrs.drop(1), (curr_result.to_s+nrs[1].to_s).to_i, results,part2)
    end
    
end

calcs.each do |calc|
    key = calc[0]
    val = calc[1]
    
    rs1 = []
    rs2 = []

    calc(key, val,val[0], rs1)
    calc(key, val,val[0], rs2, true)

    if rs1.include?(key)
        sum1 += key       
    end 
    if rs2.include?(key)
        sum2 += key       
    end   
end

puts sum1
puts sum2