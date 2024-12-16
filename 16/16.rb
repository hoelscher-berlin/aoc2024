file = "input.txt"
sum1 = 0
sum2 = 0
map = []
s = e = []
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
        if v != "#"
            [0,1,2,3].each do |o| # north, east, south, west
                q << [y,x,o]
            end 
        end
        if v == "S"
            s = [y,x]
        elsif v == "E"
            e = [y,x]
        end
    end

    map << r

end

ylen = map.length
xlen = map[0].length

prettyprint(map)

def scan(map,x,y)
    #puts "scanning for neighbors of "+y.to_s+", "+x.to_s
    reachable = []
    [[-1,0],[0,1],[1,0],[0,-1]].each_with_index do |dir,o|
        #puts "checking "+(y+dir[0]).to_s+", "+(x+dir[1]).to_s+": "+map[y+dir[0]][x+dir[1]]
        if map[y+dir[0]][x+dir[1]] != "#"
            #puts "found nachbar"
            reachable << [y+dir[0],x+dir[1],o]
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

puts q.inspect

# init
q.each do |n|
    dist.store(n, 2**100)
    pre.store(n, nil)
end
dist[[y,x,o]] = 0
#puts dist.inspect
#puts pre.inspect

def dist_between(u,v)
    #puts "checking between "+u.inspect+" and "+v.inspect
    if u[2] == v[2]
        #puts 1
        return 1
    else
        d = (u[2]-v[2]).abs
        if d > 2
            d = 4-d
        end
        #puts d*1000+1
        return d*1000+1
    end
end
# dist update
def dist_update(u,v,dist,pre)
    alt = dist[u]+dist_between(u,v)
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
    vs = scan(map,u[1],u[0])
    #puts "found vs: "+vs.inspect
    vs.each do |v|
        if q.include?(v)
            #puts "PING"
            dist_update(u,v,dist,pre)
            #puts dist.inspect
        end
    end
    puts q.length
end

#dist.each do |k,v|
#    if v < 2**100
#        puts k.inspect + ": " + v.to_s
#    end
#end

poss = []

dist.each do |k,v|
    if k[0]==e[0] && k[1] == e[1]
        poss << [k,v]
    end
end

#r.each do |n|
#    puts n.inspect
#    dist[n] = (n[2]-o).abs*1000+1
#end
#puts dist.inspect

min = poss.min_by {|x| x[1]}

#pre.each do |k,v|
#    if v
#        puts k.inspect + ": " + v.to_s
#    end
#end 

def find_all_paths(preds, target, path = [])
    # Base case: if the target is nil, return the current path
    return [path] if target.nil?
    paths = []
    if preds[target]
        preds[target].each do |predecessor|
        # Recursively find all paths from the predecessor to the source
        paths += find_all_paths(preds, predecessor, [target] + path)
        end
    else
        # If there are no predecessors, just add the target to the path
        paths << ([target] + path)
    end
    paths
end

paths = find_all_paths(pre,min[0])

paths.each do |p|
    p.each do |c|
        if map[c[0]][c[1]] != "O"
            sum2+=1
        end
        map[c[0]][c[1]] = "O"
    end
end

prettyprint(map)
puts sum2