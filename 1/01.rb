### part 1 ###

def find_smallest(arr)
    i = 1 << 100
    arr.each do |elem|
        if elem < i
            i = elem
        end
    end
    return i
end

sum = 0

t1 = []
t2 = []

File.open("input.txt").each do |line|
    l = line.split
    t1 << l[0].to_i
    t2 << l[1].to_i
end

t1_2 = t1.dup
t2_2 = t2.dup

while t1.length > 0
    s1 = find_smallest(t1)
    s2 = find_smallest(t2)
    t1.delete_at(t1.index(s1))
    t2.delete_at(t2.index(s2))
    s = s1-s2  
    if s < 0 
        s= -s
    end
    sum+=s
end

puts sum

t1 = t1_2.dup
t2 = t2_2.dup

sum = 0
### part 2 ###
t1.each do |elem|
    s=0
    occ=0
    t2.each do |el2|
        if el2==elem
            occ+=1
        end
    end
    sum+=elem*occ
end

puts sum