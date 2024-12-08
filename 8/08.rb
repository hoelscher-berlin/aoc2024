sum1 = 0
sum2 = 0

files = ["example.txt", "input.txt"]
file = files[1]

grid = []

$xlen=0
$ylen=0
File.open(file).each do |line|
    $xlen = line.strip.length
    $ylen+=1
end

File.open(file).each_with_index do |line,y|
    grid << line.strip.split(//)
end

antennas = {}

def inbound_y(val)
    return val >= 0 && val < $ylen
end

def inbound_x(val)
    return val >= 0 && val < $xlen
end

grid.each_with_index do |row,y|
    row.each_with_index do |val,x|
        if val != "."
            if !antennas.key?(val)
                antennas[val]=[[y,x]]
            else
                antennas[val] << [y,x]
            end
        end
    end
end

def prettyprint(grid)
    grid.each_with_index do |l,y|
        l.each_with_index do |val,x|
            print val
            print " "
        end
        puts
    end
    puts
end

antennas.each do |key,coords|
    coords.each_with_index do |c1,i|
        coords.each_with_index do |c2,j|
            if i==j
                next
            end
            # do some vectormagic
            ay = 2*c1[0]-c2[0]
            ax = 2*c1[1]-c2[1]

            if !(inbound_y(ay) && inbound_x(ax))
                next
            end
            if grid[ay][ax]!="#"
                grid[ay][ax]="#"
                sum1+=1
            end    
            puts "Possible antinode for "+key+" at y:"+ay.to_s+", x:"+ax.to_s
        end
    end
end

prettyprint(grid)
puts sum1

# part 2
antennas.each do |key,coords|
    coords.each_with_index do |c1,i|
        coords.each_with_index do |c2,j|
            if i==j
                next
            end
            # do some more flexible vectormagic
            t = 0
            while(true)
                ay = c1[0]+t*(c1[0]-c2[0])
                ax = c1[1]+t*(c1[1]-c2[1])

                if !(inbound_y(ay) && inbound_x(ax))
                    break
                else
                    if grid[ay][ax]!="#"
                        grid[ay][ax]="#"
                        sum2+=1
                    end
                    puts "Possible antinode for "+key+" at y:"+ay.to_s+", x:"+ax.to_s
                end
                t += 1
            end
        end
    end
end

prettyprint(grid)
puts sum1
puts sum1+sum2