require 'set'
file = "input.txt"
xlen = 71
ylen = 71
stop = 1024

sum1 = 0
sum2 = 0
map = Array.new (ylen) {Array.new(xlen) {"."}}
s = [0,0]
e = [ylen-1,xlen-1]
q = []
bytes = []

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

File.open(file).each_with_index do |r,i|
    r = r.strip.split(",").map {|i| i.to_i}
    bytes << r
    
    if i < stop
        map [r[1]][r[0]] = "#"
    end
end

map.each_with_index do |l,y|
    l.each_with_index do |val,x|
        q << [y,x]
    end
end

def inbound(x,y,xlen,ylen)
    return x >= 0 && x < xlen && y >= 0 && y < ylen
end 

def scan(map,x,y,xlen,ylen)
    #puts "scanning for neighbors of "+y.to_s+", "+x.to_s
    reachable = []
    [[-1,0],[0,1],[1,0],[0,-1]].each do |dir|
        #puts "checking "+(y+dir[0]).to_s+", "+(x+dir[1]).to_s+": "+map[y+dir[0]][x+dir[1]]
        if inbound(x+dir[1],y+dir[0],xlen,ylen)    
            if map[y+dir[0]][x+dir[1]] != "#"
                #puts "found nachbar"
                reachable << [y+dir[0],x+dir[1]]
            end
        end
    end
    reachable
end

# start position and orientation
x=s[1]
y=s[0]
o=1
dist = {}
pre = {}

# init
q.each do |n|
    dist.store(n, 2**100)
    pre.store(n, nil)
end
dist[[y,x]] = 0
#puts dist.inspect
#puts pre.inspect

# dist update
def dist_update(u,v,dist,pre)
    alt = dist[u]+1
    if alt < dist[v]
        dist[v] = alt
        pre[v] = [u]
    elsif alt == dist[v]
        pre[v].append(u)
    end
end

def find_min(q,dist)
    min = 2**100
    minnode = q[0]
    q.each do |n|
        if dist[n] < min
            min = dist[n]
            minnode = n
        end
    end
    minnode
end

while(!q.empty?)
    u = find_min(q,dist)
    if u[0] == e[0] && u[1] == e[1]
        break
    end
    #puts u.inspect
    q.delete(u)
    vs = scan(map,u[1],u[0],xlen,ylen)
    #puts "found vs: "+vs.inspect
    vs.each do |v|
        if q.include?(v)
            #puts "PING"
            dist_update(u,v,dist,pre)
            #puts dist.inspect
        end
    end
end

puts dist[[e[0],e[1]]]

def find_path(map, start, goal, xlen, ylen)
    return [] if start == goal

    visited = Set.new
    stack = [[start, [start]]] # Stack enthält Paare von (aktueller Punkt, aktueller Pfad)

    until stack.empty?
        current, path = stack.pop

        next if visited.include?(current)

        visited.add(current)

        neighbors = scan(map, current[1], current[0], xlen, ylen)

        neighbors.each do |neighbor|
            return path + [neighbor] if neighbor == goal
            if !visited.include?(neighbor)
                stack.push([neighbor, path + [neighbor]])
            end
        end
    end

    [] # Rückgabe eines leeren Arrays, wenn kein Weg gefunden wurde
end

path = find_path(map, s,e,xlen,ylen)

bytes.each_with_index do |b,i| 
    if i < stop # skip first 1024/12
        next
    end
    map[b[1]][b[0]] = "#"
    if path.include?([b[1],b[0]]) # path broken, compute new path
        path=find_path(map, s,e,xlen,ylen) 
        if path == []
            puts b[0].to_s+","+b[1].to_s
            break
        end  
    end
end

