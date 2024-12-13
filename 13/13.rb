sum1 = 0
sum2 = 0
games = []
ax = bx = ay = by = x = y = 0

File.open("example.txt").each_with_index do |line,i|
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

puts games.inspect

puts sum1
puts sum2