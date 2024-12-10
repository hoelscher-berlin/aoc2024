sum1 = 0
sum2 = 0

files = ["example.txt", "input.txt"]
file = files[1]

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
        val.to_i.times do |k|
            disk << ctr.to_s
            #puts (j+k).to_s + " 0 space"
            free_spaces[j+k] = 0
        end
        count_nrs += val.to_i
    else
        free_spaces[j] = val.to_i
        #puts free_spaces.inspect
        val.to_i.times {disk << "."}
        ((val.to_i)-1).times do |k|
            #puts (j+1+k).to_s + " 0 space"
            free_spaces[j+1+k] = 0
        end
        ctr+=1
    end
end

disk2 = Marshal.load(Marshal.dump(disk))

def find_first_dot(d, ok_up_to)
    d[ok_up_to..-1].each_with_index do |val,i|
        if val =="."
            return ok_up_to+i
        end
    end
end

def check_if_done(d, cnt, ok=0)
    count = 0
    d[ok..-1].each do |val|
        if val == "."
            break
        else
            count+=1
        end
    end

    return ok+count
end

def checksum(d)
    sum = 0
    d.each_with_index do |val,i|
        if val == "."
            next
        else
            sum += val.to_i*i
        end
    end
    sum
end

#puts check_if_done(disk, count_nrs)

ok_up_to = 0

disk.reverse.each_with_index do |val,i|
    if val!="."
        j = find_first_dot(disk, ok_up_to)
        k = disk.length-1-i
        #puts "swapping "+k.to_s+" and "+j.to_s
        disk[k], disk[j] = disk[j], disk[k]
        #puts disk.join("")
    end
    # very inefficient, but it does the deed
    ok_up_to = check_if_done(disk, count_nrs, ok_up_to)
    #puts ok_up_to
    if ok_up_to == count_nrs
        break
    end
end



puts checksum(disk)

# part 2

#puts files.inspect

disk = disk2

#puts disk.join(' ')

files.reverse.each_with_index do |f,i|
    fid = files.length-1-i

    foundkey = 0
    freespacelength = 0
    filelength = 0
    success = false
    free_spaces.each do |key,length|
        if length >= f[1] && key < f[0]
            #puts "file "+fid.to_s+" would fit into space nr. "+key.to_s
            # some swapping action
            f[1].times do |j|
                #puts "swapping "+(f[0]+j).to_s+" and "+(key+j).to_s
                disk[f[0]+j], disk[key+j] = disk[key+j], disk[f[0]+j]
            end
            #puts disk.join(' ')
            # update free spaces - only those to the left need to be updated
            foundkey = key
            freespacelength = length
            filelength = f[1]
            # that should be it
            success = true
            break
        end 
    end
    if success
        free_spaces[foundkey]=0
        free_spaces[foundkey+filelength] = freespacelength-filelength
    end
    #puts free_spaces.inspect
end

puts checksum(disk)