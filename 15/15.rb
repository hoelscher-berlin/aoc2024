sum1 = 0
sum2 = 0
map = []
moves = []

mapb = true

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

File.open("e1.txt").each do |r|
    r = r.strip
    if r == ""
        mapb = false
        next
    end

    if mapb
        map << r.split(//)
    else
        moves.concat r.split(//)
    end    
end

ylen = map.length
xlen = map[0].length
ry = 0
rx = 0

map.each_with_index do |row,y|
    row.each_with_index do |val,x|
        if val=="@"
            ry = y
            rx = x
        end
    end
end


prettyprint(map)

moves.each do |m|
    dy = 0
    dx = 0

    case m
    when "^"
        dy = -1
    when ">"
        dx = 1
    when "v"
        dy = 1
    when "<"
        dx = -1
    end

    ny = ry + dy
    nx = rx + dx

    if map[ny][nx] == "#"
        next
    elsif map[ny][nx]=="."
        map[ry][rx] = "."
        map[ny][nx] = "@"
        rx = nx
        ry = ny
    else
        # pushing boxes
        case m
        when "^"
            (1..ny-1).to_a.reverse.each do |y|
                if map[y][rx] == "."
                    map[ry][rx]="."
                    map[ny][nx]="@"
                    map[y][rx]="O"
                    rx = nx
                    ry = ny
                    break
                elsif map[y][rx] == "#"
                    break
                end
            end 
        when ">"
            (nx+1..xlen-2).each do |x|
                if map[ry][x] == "."
                    map[ry][rx]="."
                    map[ny][nx]="@"
                    map[ry][x]="O"
                    rx = nx
                    ry = ny
                    break
                elsif map[ry][x] == "#"
                    break
                end
            end
        when "v"
            (ny+1..ylen-2).each do |y|
                if map[y][rx] == "."
                    map[ry][rx]="."
                    map[ny][nx]="@"
                    map[y][rx]="O"
                    rx = nx
                    ry = ny
                    break
                elsif map[y][rx] == "#"
                    break
                end
            end
        when "<"
            (1..nx-1).to_a.reverse.each do |x|
                if map[ry][x] == "."
                    map[ry][rx]="."
                    map[ny][nx]="@"
                    map[ry][x]="O"
                    rx = nx
                    ry = ny
                    break
                elsif map[ry][x] == "#"
                    break
                end
            end
        end
    end
end

map.each_with_index do |row,y|
    row.each_with_index do |v,x|
        if v == "O"
            sum1 += 100*y+x
        end
    end
end

prettyprint(map)
puts sum1

# part 2
map = []

File.open("input.txt").each do |r|
    r = r.strip
    if r == ""
        break
    end

    line = []

    r.split(//).each do |v|
        if v == "." || v == "#"
            line << v
            line << v
        elsif v == "O"
            line << "["
            line << "]"
        else
            line << "@"
            line << "."
        end
    end
    map << line
end

prettyprint(map)