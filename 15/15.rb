file = "input.txt"
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

File.open(file).each do |r|
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

File.open(file).each do |r|
    r = r.strip
    if r == ""
        break
    end

    line = []

    r.split(//) do |v|
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

map.each_with_index do |row,y|
    row.each_with_index do |val,x|
        if val=="@"
            ry = y
            rx = x
        end
    end
end



def pushable(map, x, y, dx, dy, blocks)
    if dx == 0
        #puts "checking from "+x.to_s+","+y.to_s
        if map[y+dy][x] == "."
            return true
        elsif map[y+dy][x] == "#"
            return false
        elsif map[y+dy][x] == "["
            if !blocks.include?([y+dy,x,"["]) && !blocks.include?([y+dy,x+1,"]"])
                blocks << [y+dy,x,"["]
                blocks << [y+dy,x+1,"]"]
            end
            return pushable(map, x, y+dy, 0, dy, blocks) && pushable(map, x+1, y+dy, 0, dy, blocks)
        elsif map[y+dy][x] == "]"
            if !blocks.include?([y+dy,x,"]"]) && !blocks.include?([y+dy,x-1,"["])
                blocks << [y+dy,x,"]"]
                blocks << [y+dy,x-1,"["]
            end
            return pushable(map, x, y+dy, 0, dy, blocks) && pushable(map, x-1, y+dy, 0, dy, blocks)
        end
    else
        if map[y][x+dx] == "."
            return true
        elsif map[y][x+dx] == "#"
            return false
        elsif map[y][x+dx] == "["
            if !blocks.include?([y,x+dx,"["])
                blocks << [y,x+dx,"["]
            end
            return pushable(map, x+dx, y, dx, dy, blocks)
        elsif map[y][x+dx] == "]"
            if !blocks.include?([y,x+dx,"]"])
                blocks << [y,x+dx,"]"]
            end
            return pushable(map, x+dx, y, dx, dy, blocks)
        end
    end
end

=begin
map[2][6] = "["
map[2][7] = "]"
prettyprint(map)
blocks = []
puts pushable(map, 6, 5, -1, blocks)
puts blocks.inspect
=end

prettyprint(map)

moves.each do |m|
    #puts "Moving "+m
    dy = 0
    dx = 0
    blocks = []

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
        # left and right is easier, same logic still applies (nearly)
        if pushable(map,rx,ry,dx,dy,blocks)
            #puts blocks.inspect
            
            if dy == 0 
                blocks.each do |b|
                    map[b[0]+dy][b[1]+dx] = b[2]
                end
                map[ry][rx] = "."
                map[ny][nx] = "@"
                rx = nx
                ry = ny
            else
                blocks.each do |b|
                    map[b[0]][b[1]] = "."
                end
                blocks.each do |b|
                    map[b[0]+dy][b[1]+dx] = b[2]
                end
                map[ry][rx] = "."
                map[ny][nx] = "@"
                rx = nx
                ry = ny
            end
        end
    end
end

prettyprint(map)

map.each_with_index do |row,y|
    row.each_with_index do |v,x|
        if v == "["
            sum2 += 100*y+x
        end
    end
end

puts sum2