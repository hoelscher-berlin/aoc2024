sum1 = 0
sum2 = 0
rules = {}
updates = []

def add_to_hash(hash, key, value)
    if hash.key?(key)
        hash[key] << value
    else
        hash[key] = [value]
    end
end

update = false
File.open("input.txt").each do |line|
    if line.strip.empty? then 
        update = true
        next 
    end
    
    if !update 
        l = line.strip.split("|")
        add_to_hash(rules,l[0],l[1])
    else
        updates << line.strip.split(",") 
    end
end

#puts rules.inspect

def check(update, ruleset)
    pass = true
    ur = update.reverse
    ur.each_with_index do |page,i|
        if ruleset.key?(page) 
            ur[i+1..-1].each do |utc|
                if ruleset[page].include?(utc)
                    pass = false
                end
            end
        end
    end
    if pass
        return update[(update.length-1)/2]
    else
        return -1
    end
end

def fix(update, ruleset)
    fixed = [update.shift]

    update.each do |page|
        fixed.each_with_index do |f,i|
            # no rule exists for element in fixed, so it should be way back
            if !ruleset.key?(f)
                fixed.insert(i, page)
                break
            end
            
            # if the page should be after the element in fixed...
            if ruleset[f].include?(page)
                # put it at last position, if we are at the end of the array
                if i==fixed.length-1
                    fixed << page
                    break
                # otherwise check at next position
                else
                    next
                end
            # else, we put it before the element in fixed
            else
                fixed.insert(i, page)
                break
            end
        end
    end

    fixed
end

# only works on example :( assuming order can be directly derived from rules
def find_out_order(ruleset)
    order = Array.new(ruleset.length)
    puts order.length
    ruleset.each do |p,r|
        puts r.length
        order[r.length-1]=p
    end
    order.prepend(ruleset[order.last][0])
    order.reverse
end

updates.each do |u|
    res = check(u,rules)
    if res != -1
        sum1 += res.to_i
    else
        fixed = fix(u,rules)
        sum2+=fixed[(fixed.length-1)/2].to_i
    end
end

puts sum1
puts sum2