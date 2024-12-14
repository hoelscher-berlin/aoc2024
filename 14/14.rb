sum1 = 0
sum2 = 0
robots = []

xlen = 101
ylen = 103

File.open("input.txt").each do |r|
    r = r.strip.split("=")
    pos = r[1].split(" ")[0].split(",").map {|i| i.to_i}
    vel = r[2].split(",").map {|i| i.to_i}
    robots << [pos,vel]
end

map = Array.new(ylen) {Array.new(xlen) {0}}

def prettyprint(grid)
    grid.each_with_index do |l,y|
        l.each_with_index do |val,x|
            if val == 0
                print " "
            else
                print val
            end
            print " "
        end
        puts
    end
    puts
end

# initial map setup
robots.each do |r|
    ry = r[0][1]
    rx = r[0][0]
    if map[ry][rx] == 0
        map[ry][rx] = 1
    else
        map[ry][rx] += 1
    end
end

20000.times do |v|
    puts v
    # tick
    robots.each do |r|
        ry = r[0][1]
        rx = r[0][0]
        vely = r[1][1]
        velx = r[1][0]

        r[0][1] = (ry + vely)%ylen
        r[0][0] = (rx + velx)%xlen

        map[ry][rx] -= 1
        map[r[0][1]][r[0][0]] += 1
    end
    if (v-189)%103 == 0
        puts v
        prettyprint(map)
    end
end

q1 = q2 = q3 = q4 = 0

map.each_with_index do |row,y|
    row.each_with_index do |val,x|
        if y < ylen/2
            if x < xlen/2
                # upper left quadrant
                q1 += map[y][x]
            elsif x > xlen/2
                # upper right quadrant
                q2 += map[y][x]
            end
        elsif y > ylen/2
            if x < xlen/2
                # lower left quadrant
                q3 += map[y][x]
            elsif x > xlen/2
                # lower right quadrant
                q4 += map[y][x]
            end
        end
    end
end

prettyprint(map)

sum1 = q1*q2*q3*q4
puts sum1