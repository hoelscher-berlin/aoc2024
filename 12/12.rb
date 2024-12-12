sum1 = 0
sum2 = 0
grid = []

File.open("input.txt").each do |line|
    grid << line.strip.split(//)
end

$ylen = grid.length
$xlen = grid[0].length
regions = []

def inbound(c)
    return c[0] < $ylen && c[0] >=0 && c[1] < $xlen && c[1] >=0
end

def find_region(g, x, y, v, r)
    g[y][x] = "."

    dirs = [[0,1],[1,0],[0,-1],[-1,0]]
    dirs.each do |d|
        ny = y+d[0]
        nx = x+d[1]

        if inbound([ny,nx]) && g[ny][nx] == v
            r[1] << [ny,nx]
            find_region(g, nx, ny, v, r)
        else
            if !r[1].include?([ny,nx])
                #puts "Fence alarm:"+ny.to_s+", "+nx.to_s
                r[2] << [ny,nx,d]
            end
        end
    end
end

grid.each_with_index do |row,y|
    row.each_with_index do |val,x|
        if val != "." # not checked yet
            r = [val, [[y,x]], []]
            find_region(grid, x, y, val, r)
            #puts "Found region:" + r.inspect
            regions << r

            sum1 += r[1].length*r[2].length
        end
    end
end

def count_h(cs)
    cnt = 1
    if cs.length==1 
        return cnt
    end
    if cs.empty?
        return 0
    end
    cs.each_with_index do |c,i|
        if i == 0
            next
        end
        if !(cs[i][0]==cs[i-1][0] && cs[i][1] == cs[i-1][1]+1)
            cnt += 1
        end
    end 
    cnt
end

def count_v(cs)
    cnt = 1
    if cs.length==1 
        return cnt
    end
    if cs.empty?
        return 0
    end
    cs.each_with_index do |c,i|
        if i == 0
            next
        end
        if !(cs[i][1]==cs[i-1][1] && cs[i][0] == cs[i-1][0]+1)
            cnt += 1
        end
    end 
    cnt
end

regions.each do |r|
    rfs = []
    lfs = []
    dfs = []
    ufs = [] 
    r[2].each do |f| 
        #puts f.inspect
        c = [f[0],f[1]]
        if (f[2] == [0,1])
            # right facing (vertical) fence
            rfs << c
        elsif (f[2] == [0,-1])
            # left facing (vertical) fence
            lfs << c
        elsif (f[2] == [1,0])
            # down facing (horizontal) fence
            dfs << c
        else
            # up facing (horizontal) fence
            ufs << c 
        end
    end

    nr_r = count_v(rfs.sort_by {|e| [e[1], e[0]]})
    nr_l = count_v(lfs.sort_by {|e| [e[1], e[0]]})
    nr_d = count_h(dfs.sort_by {|e| [e[0], e[1]]})
    nr_u = count_h(ufs.sort_by {|e| [e[0], e[1]]})

    sum2+=(nr_r+nr_l+nr_d+nr_u)*r[1].length
end



puts sum1
puts sum2