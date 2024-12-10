sum1 = 0
sum2 = 0
t1 = []

File.open("input.txt").each do |line|
    t1 << line.strip.split(//)
end

$ylen = t1.length
$xlen = t1[0].length

trailheads = []

t1.each_with_index do |line,y|
    line.each_with_index do |val,x|
        t1[y][x] = val.to_i
        if val == "0"
            trailheads << [y,x]
        end
    end
end

def inbound(c)
    return c[0] < $ylen && c[0] >=0 && c[1] < $xlen && c[1] >=0
end

def find_peaks(grid, c, found)
    if grid[c[0]][c[1]] == 9
        if !found.include?([c[0],c[1]])
            found << [c[0],c[1]]
        end
        return
    end
    dirs = [-1,0,1] 
    #puts "we are currently at "+c.inspect
    dirs.each do |dy|
        dirs.each do |dx|
            ny = c[0]+dy
            nx = c[1]+dx
            nc = [ny,nx]
            #puts "nc would be"+nc.inspect
            if (dx+dy).abs==1 && inbound(nc) && grid[ny][nx] == grid[c[0]][c[1]] + 1
                #puts "going to "+nc.inspect
                find_peaks(grid, nc, found)
            end
        end
    end
end

#puts trailheads.inspect
#puts

trailheads.each do |th|
    #if th != [0,2]
    #    next
    #end
    #puts "checking th "+th[0].to_s+","+th[1].to_s
    res = []
    find_peaks(t1, th,res)
    #puts res.inspect
    #puts res.length
    sum1 += res.length
end

puts sum1