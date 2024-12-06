sum1 = 0
sum2 = 0

file = "input.txt"

xlen=0
ylen=0
File.open(file).each do |line|
    xlen = line.strip.length
    ylen+=1
end

#puts xlen
#puts ylen

guarddirs = ["^", ">", "v", "<"]
guarddir = ""
startgx = gx = 0
startgy = gy = 0

grid = []

def prettyprint(grid,gx,gy,guarddir)
    grid.each_with_index do |l,y|
        l.each_with_index do |val,x|
            if y == gy && x == gx
                print guarddir
            else
                print val
            end
            print " "
        end
        puts
    end
    puts
end


File.open(file).each_with_index do |line,y|
    grid << line.strip.split(//)
end

grid.each_with_index do |l,y|
    l.each_with_index do |val,x|
        if guarddirs.include?(val)
            startgx = gx = x
            startgy = gy = y
            guarddir = grid[y][x]
            grid[y][x]="."
        end
    end
end

grid2 = Marshal.load(Marshal.dump(grid))

#prettyprint(grid,gx,gy,guarddir)

#puts gx
#puts gy


while true
    case guarddir
    when "^"
        dgx = 0
        dgy = -1
    when ">"
        dgx = 1
        dgy = 0
    when "<"
        dgx = -1
        dgy = 0
    when "v"
        dgx = 0
        dgy = 1
    end

    newx = gx + dgx
    newy = gy + dgy

    if !(newx < xlen && newx >= 0 && newy < ylen && newy >= 0)
        break
    end
    
    case grid[newy][newx]
    when "."
        grid[newy][newx]="X"
        sum1 += 1
        gy = newy
        gx = newx
    when "X"
        gy = newy
        gx = newx
    when "#"
        guarddir = guarddirs[(guarddirs.index(guarddir)+1)%4]
    end
    #prettyprint(grid, gx, gy, guarddir)
    #puts
end

#prettyprint(grid, gx, gy, guarddir)


puts sum1

# part 2!

def check_loop(grid, gx, gy, guarddir, obsx, obsy)
    gx = 59
    gy = 71
    guarddir = "^"
    #puts "ding"
    #puts "checking loop by putting obstacle at "+obsx.to_s+", "+obsy.to_s
    oldval = grid[obsy][obsx]
    grid[obsy][obsx] = "#"
    guarddirs = ["^", ">", "v", "<"]
    
    xlen = grid[0].length
    ylen = grid.length

    seen = []
    while true
        #puts "oldx "+oldx.to_s + " oldy "+oldy.to_s + " " + olddir
        #puts "posx "+gx.to_s + " posy "+gy.to_s + " " + guarddir

        case guarddir
        when "^"
            dgx = 0
            dgy = -1
        when ">"
            dgx = 1
            dgy = 0
        when "<"
            dgx = -1
            dgy = 0
        when "v"
            dgx = 0
            dgy = 1
        end
    
        newx = gx + dgx
        newy = gy + dgy
    
        if !(newx < xlen && newx >= 0 && newy < ylen && newy >= 0)
            #puts "LOOP FAIL :("
            break
        end
        
        if grid[newy][newx] == "#"
            guarddir = guarddirs[(guarddirs.index(guarddir)+1)%4]
            if seen.include?([gx,gy,guarddir])
                #puts "LOOP FOUND!" 
                #puts seen.inspect
                grid[obsy][obsx] = oldval
                return true
            end
        else
            gy = newy
            gx = newx
        end
        #prettyprint(grid, gx, gy, guarddir)
        #puts
        seen << [gx, gy, guarddir]
    end
    grid[obsy][obsx] = oldval
    return false
end

gx = startgx
gy = startgy
guarddir = "^"
grid = grid2

obstacles = []

while true
    case guarddir
    when "^"
        dgx = 0
        dgy = -1
    when ">"
        dgx = 1
        dgy = 0
    when "<"
        dgx = -1
        dgy = 0
    when "v"
        dgx = 0
        dgy = 1
    end

    newx = gx + dgx
    newy = gy + dgy

    if !(newx < xlen && newx >= 0 && newy < ylen && newy >= 0)
        break
    end

    if grid[newy][newx]=="#"
        guarddir = guarddirs[(guarddirs.index(guarddir)+1)%4]
        #puts "turn!"
    else
        #if lookright(grid, gx, gy, guarddir)
            #grid[newy][newx] = "O"
        if !(newx == startgx && newy == startgy)
            if check_loop(grid, gx, gy, guarddir, newx, newy)
                if !obstacles.include?([newx,newy])
                    obstacles << [newx,newy]
                end
            end
        end 
        #end
        gy = newy
        gx = newx
        #puts "step!"
    end
    #prettyprint(grid, gx, gy, guarddir)
end
puts obstacles.length