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

def find_peaks(grid, c, found, nr)
    if grid[c[0]][c[1]] == 9
        if !found.include?([c[0],c[1]])
            found << [c[0],c[1]]
        end 
        #puts "ping"
        nr << 1
        return
    end
    dirs = [-1,0,1] 
    dirs.each do |dy|
        dirs.each do |dx|
            ny = c[0]+dy
            nx = c[1]+dx
            nc = [ny,nx]
            if (dx+dy).abs==1 && inbound(nc) && grid[ny][nx] == grid[c[0]][c[1]] + 1
                find_peaks(grid, nc, found, nr)
            end
        end
    end
end

trailheads.each do |th|
    res = []
    nr = []
    find_peaks(t1, th,res,nr)
    sum1 += res.length
    sum2 += nr.length
end


puts sum1
puts sum2