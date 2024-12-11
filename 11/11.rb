sum1 = 0
sum2 = 0
pebbles = []

File.open("input.txt").each do |line|
    pebbles = line.strip.split(" ").map {|i| i.to_i}
end

ps = Hash.new(0)

pebbles.each do |p| 
    if ps.key?(p)
        ps[p]+=1
    else
        ps[p] = 1
    end
end

#puts ps.inspect

def blink(ps)
    newps = Marshal.load(Marshal.dump(ps))
    ps.each do |k,i| 
	dnum = k.to_s.length
        if k == 0
            newps[1]+=i
            newps[0]-=i
	elsif dnum % 2 == 0
            newps[k]-=i
            newps[k.digits[dnum/2..-1].join.reverse.to_i] += i
            newps[k.digits[0..dnum/2-1].join.reverse.to_i] += i
        else
            newps[k]-=i
            newps[k*2024] += i
        end
	if newps[k] == 0
            newps.delete(k)
        end
    end
    return newps
end

#puts pebbles.inspect

75.times do |t|
    puts t
    ps = blink(ps)
    puts ps.inspect
end

ps.each do |k,v|
    sum1+=v
end

puts sum1
puts sum2
