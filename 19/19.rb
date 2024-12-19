file = "input.txt"

sum1 = 0
$sum2 = 0

patterns = Hash.new
towels = []
$poss_arrs = Hash.new {0}

File.open(file).each_with_index do |r,i|
    if i == 0
        r.strip.split(", ").each do |p|
            patterns[p] = 1
        end
    elsif i > 1
        towels << r.strip
    end
end

#puts towels.inspect
#patterns.each do |k,v|
#    puts k.inspect + ": " + v.to_s
#end

def check_from(str, patterns)
    #puts "checking "+str
    if patterns.key?(str)
        return true
    else
        str.length.times do |i|
            if patterns.key?(str[0..i])
                #puts "found partial "+str[0..i]
                if check_from(str[i+1..-1],patterns)
                    return true
                end
            end
        end
    end
    return false
end

def check_from2(str, patterns,partial=[])
    #puts "checking "+str
    if $poss_arrs.key?(str)
        #puts "already found pattern"+str
        return $poss_arrs[str]
    end
    val = 0
    if patterns.key?(str)
        #puts (partial+[str]).inspect
        val +=1
    end

    str.length.times do |i|
        if patterns.key?(str[0..i])
            #puts "found partial "+str[0..i]
            val += check_from2(str[i+1..-1],patterns,partial+[str[0..i]])
        end
    end

    if val != 0
        $poss_arrs[str] = val
    end
    #puts $poss_arrs.inspect
    return val
end

towels.each do |t|
    $results = []
    #puts
    #puts "checking "+t
    if check_from(t,patterns)
        #puts "towel "+t+" is possible"
        sum1+=1
    end
    $sum2 += check_from2(t,patterns)
    #puts p.inspect
end

puts sum1
puts $sum2