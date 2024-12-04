sum = 0
t1 = []

File.open("input.txt").each do |line|
    t1 << line
end


def parse(line,sum)
    #puts "Line: " + line
    char = line.slice!(0)
    if char == "m"
        char = line.slice!(0)
        if char == "u"
            char = line.slice!(0)
            if char == "l"
                char = line.slice!(0)
                if char == "("
                    char = line.slice!(0)
                    if char =~ /\A\d+\z/
                        if line.slice(0) =~ /\A\d+\z/
                            char += line.slice!(0)
                            if line.slice(0) =~ /\A\d+\z/
                                char += line.slice!(0)
                            end
                        end
                        nr1 = Integer(char)
                        char = line.slice!(0)
                        if char ==","
                            char = line.slice!(0)
                            if char =~ /\A\d+\z/
                                if line.slice(0) =~ /\A\d+\z/
                                    char += line.slice!(0)
                                    if line.slice(0) =~ /\A\d+\z/
                                        char += line.slice!(0)
                                    end
                                end
                                nr2 = Integer(char)
                                char = line.slice!(0)
                                if char ==")"
                                    sum += nr1*nr2
                                    #puts nr1.to_s+"*"+nr2.to_s+" = "+(nr1*nr2).to_s
                                end
                            end    
                        end
                    end
                end
            end
        end
    end
    if line != "" 
        sum = parse(line,sum)
    end
    sum
end

def parse2(line,sum,e=true)
    #puts "Line: " + line + "sum: "+sum.to_s
    char = line.slice!(0)
    
    if char == "d" #alert!!!!
        char = line.slice!(0)
        if char =="o"
            char = line.slice!(0)
            if char =="("
                char = line.slice!(0)
                if char ==")"
                    e=true
                    sum = parse2(line,sum,e)
                end
            end
            if char =="n"
                char = line.slice!(0)
                if char =="'"
                    char = line.slice!(0)
                    if char =="t"
                        char = line.slice!(0)
                        if char =="("
                            char = line.slice!(0)
                            if char==")"
                                e=false
                                sum = parse2(line,sum,e)
                            end
                        end
                    end
                end
            end
        end
    end
    
    if char == "m" && e
        char = line.slice!(0)
        if char == "u"
            char = line.slice!(0)
            if char == "l"
                char = line.slice!(0)
                if char == "("
                    char = line.slice!(0)
                    if char =~ /\A\d+\z/
                        if line.slice(0) =~ /\A\d+\z/
                            char += line.slice!(0)
                            if line.slice(0) =~ /\A\d+\z/
                                char += line.slice!(0)
                            end
                        end
                        nr1 = Integer(char)
                        char = line.slice!(0)
                        if char ==","
                            char = line.slice!(0)
                            if char =~ /\A\d+\z/
                                if line.slice(0) =~ /\A\d+\z/
                                    char += line.slice!(0)
                                    if line.slice(0) =~ /\A\d+\z/
                                        char += line.slice!(0)
                                    end
                                end
                                nr2 = Integer(char)
                                char = line.slice!(0)
                                if char ==")"
                                    sum += nr1*nr2
                                    #puts sum
                                    #puts nr1.to_s+"*"+nr2.to_s+" = "+(nr1*nr2).to_s
                                end
                            end    
                        end
                    end
                end
            end
        end
    end
    if line != "" 
        sum = parse2(line,sum,e)
    end
    #puts sum
    sum
end
sum1=0
sum2=0
t2 = Marshal.load(Marshal.dump(t1))
#part1
t1.each do |l|
    sum1+= parse(l,0)
end

t2.each do |l|
    sum2+= parse2(l,0)
end

puts sum1
puts sum2