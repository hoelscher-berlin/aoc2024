sum1 = 0
sum2 = 0

files = ["example.txt", "input.txt"]
file = files[0]

disk = []

$len = 0
input = []

File.open(file).each do |line|
    # small example
    #line = "12345"
    line = line.strip
    
    $len = line.strip.length
    input = line.split(//)
end

count_nrs = 0
ctr = 0

files=[]
free_spaces = {}

input.each_with_index do |val,i|
    j = disk.length
    if i%2 == 0
        # file id ctr starts at j and has val.to_i length
        files[ctr] = [j, val.to_i]
        val.to_i.times {disk << ctr.to_s}
        count_nrs += val.to_i
    else
        # beginning at j, there is a free space of length val.to_i
        free_spaces[j] = val.to_i
        val.to_i.times {disk << "."}
        ctr+=1
    end
end

def find_first_dot(d)
    d.each_with_index do |val,i|
        if val =="."
            return i
        end
    end
end

def check_if_done(d, cnt)
    count = 0
    d.each do |val|
        if val == "."
            break
        else
            count+=1
        end
    end

    if count == cnt
        return true
    else
        return false
    end
end

def checksum(d)
    sum = 0
    d.each_with_index do |val,i|
        if val == "."
            break
        else
            sum += val.to_i*i
        end
    end
    sum
end

disk.reverse.each_with_index do |val,i|
    if val!="."
        j = find_first_dot(disk)
        k = disk.length-1-i
        #puts "swapping "+k.to_s+" and "+j.to_s
        disk[k], disk[j] = disk[j], disk[k]
        #puts disk.join("")
    end
    # very inefficient, but it does the deed
    if check_if_done(disk,count_nrs)
        break
    end
end

puts files.inspect
puts free_spaces.inspect

puts checksum(disk)

puts sum1
puts sum1+sum2