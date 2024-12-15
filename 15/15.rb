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

prettyprint(map)
puts moves
