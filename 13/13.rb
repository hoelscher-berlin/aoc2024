sum1 = 0
sum2 = 0
games = []
ax = bx = ay = by = x = y = 0

File.open("input.txt").each_with_index do |line,i|
    if i%4 == 0
        line = line.strip.split("+")
        ax = line[1][0..1].to_i
        ay = line[2][0..1].to_i
    elsif i%4 == 1
        line = line.strip.split("+")
        bx = line[1][0..1].to_i
        by = line[2][0..1].to_i
    elsif i%4 == 2
        line = line.strip.split(",")
        x = line[0].split("=")[-1].to_i
        y = line[1].split("=")[-1].to_i
    else 
        games << [ax,ay,bx,by,x,y] 
    end
end

#puts games.inspect

games.each do |g|
    a = g[0]
    c = g[1]
    b = g[2]
    d = g[3]
    x = g[4]
    y = g[5]

    divby = (a*d*1.0 - b*c*1.0)

    nx = (x*d-b*y)/divby
    ny = (-c*x + a*y)/divby


    if !(nx <= 100 && ny <= 100 && nx%1==0 && ny%1 == 0)
        next
    end

    #puts nx
    #puts ny

    #puts 3*nx + ny
    #puts

    sum1+=3*nx + ny
end

games.each do |g|
    a = g[0]
    c = g[1]
    b = g[2]
    d = g[3]
    x = g[4] + 10000000000000
    y = g[5] + 10000000000000

    divby = (a*d*1.0 - b*c*1.0)

    nx = (x*d-b*y)/divby
    ny = (-c*x + a*y)/divby


    if !(nx%1==0 && ny%1 == 0)
        next
    end

    #puts nx
    #puts ny

    #puts 3*nx + ny
    #puts

    sum2+=3*nx + ny
end

puts sum1
puts sum2