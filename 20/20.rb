require 'set'
file = "input.txt"

sum1 = 0
sum2 = 0
map = []
s = [0,0]
e = [0,0]
q = []

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

File.open(file).each_with_index do |r,y|
    r = r.strip.split(//)

    r.each_with_index do |v,x|
        q << [y,x]
        if v == "S"
            s = [y,x]
        elsif v == "E"
            e = [y,x]
        end
    end

    map << r

end

xlen = map[0].length
ylen = map.length

def inbound(x,y,xlen,ylen)
    return x >= 0 && x < xlen && y >= 0 && y < ylen
end 

$possible_cheats = []

def scan(map,x,y,xlen,ylen,find_walls)
    reachable = []
    [[-1,0],[0,1],[1,0],[0,-1]].each do |dir|
        if inbound(x+dir[1],y+dir[0],xlen,ylen)    
            if map[y+dir[0]][x+dir[1]] != "#"
                reachable << [y+dir[0],x+dir[1]]
            end
            if find_walls && map[y+dir[0]][x+dir[1]] == "#"
                if !$possible_cheats.include?([y+dir[0],x+dir[1],y,x])
                    $possible_cheats << [y+dir[0],x+dir[1],y,x]
                end
            end
        end
    end
    reachable
end

def find_path(map, start, goal, xlen, ylen, find_walls = false)
    return [] if start == goal

    visited = Set.new


    stack = [[start, [start]]]

    until stack.empty?
        current, path = stack.pop

        next if visited.include?(current)

        visited.add(current)

        neighbors = scan(map, current[1], current[0], xlen, ylen, find_walls)

        neighbors.each do |neighbor|
            return path + [neighbor] if neighbor == goal
            if !visited.include?(neighbor)
                stack.push([neighbor, path + [neighbor]])
            end
        end
    end

    []
end

path = find_path(map, s,e,xlen,ylen,true)

length_from_coord = Hash.new{}
path.each_with_index do |p,i|
    length_from_coord[p] = path.length - 1 - i
end

len = path.length-1

saved = 0

$possible_cheats.each_with_index do |c,i|
    new_start_y = c[0]+(c[0]-c[2])
    new_start_x = c[1]+(c[1]-c[3])
    new_start = [new_start_y,new_start_x]
    if length_from_coord.key?(new_start)
        diff = length_from_coord[c[2..3]] - length_from_coord[new_start] - 2
        if diff > 0
            if diff >= 100 
                saved += 1
            end
        end
    end
end

puts saved

def reachable_coords_from_cheat_start(map, start, ps = 20)
    xlen = map[0].length
    ylen = map.length

    start_y, start_x = start[0], start[1]
    max_distance = ps
    coordinates = []

    (-max_distance..max_distance).each do |dy|
        (-max_distance..max_distance).each do |dx|
            if dy.abs + dx.abs <= max_distance
                newy = start_y + dy
                newx = start_x + dx
                d = dy.abs + dx.abs
                coordinates << [newy, newx, d] if inbound(newx, newy,xlen, ylen) && map[newy][newx] != "#"
            end
        end
    end
    coordinates
end

saved = 0

path.each_with_index do |p,i|
    reachable = reachable_coords_from_cheat_start(map,p)
    reachable.each do |r|
        oldl = length_from_coord[p]
        newl = length_from_coord[r[0..1]]+r[2]

        if oldl-newl >= 100
            saved += 1
        end
    end
end

puts saved