sum = 0
t1 = []

File.open("input.txt").each do |line|
    l = line.split
    lnew = []
    l.each do |nr|
        lnew << nr.to_i
    end
    t1 << lnew
end

def check_report(report)
    oldnr = report[0]
    diff = report[1]-report[0]
    if diff > 0
        sign = 1
    elsif diff < 0
        sign = -1
    else
        sign = 0
    end 

    if diff.abs > 3
        f = true
    else
        f = false
    end
    report.each_with_index do |nr,i|
        if i == 0
            next
        end
       diff = nr-oldnr
       #puts oldnr.to_s+" "+nr.to_s+" "+"diff is "+diff.to_s
       if (diff > 0 && sign == -1) || (diff < 0 && sign == 1) || diff == 0
        f = true
        #puts "falsches vorzeichen"
        break
       else 
        if diff.abs > 3
            f = true
            #puts "abstand zu groß"
            break
        end
       end    
       oldnr = nr
    end
    return f
end

#part1

t1.each do |report|
    f = check_report(report)
    if f==false
        sum+=1
        #puts "ok"
    end
end
puts sum

#part2

sum = 0
t1.each do |report|
    # first try
    f = check_report(report)
    if f==false
        #puts "report passed:"
        #puts report.inspect
    else # second try
        # try with one element removed
        report.each_with_index do |nr,i|
            rnew = report.dup
            rnew.delete_at(i)
            if !check_report(rnew)
                #puts "report passed after removing:"
                #puts rnew.inspect
                f = false
                break
            end
        end
    end    
    if f==false
        sum+=1
    end
end

puts sum