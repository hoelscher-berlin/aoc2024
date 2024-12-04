sum1 = 0
sum2 = 0
t1 = []
dirs = [1,2,3,4,5,6,7,8]

File.open("input.txt").each do |line|
    t1 << line.strip.split(//)
end

def check(input,r,c,dir)
    val = 0
    rlen = input.length
    clen = input[0].length
    
    case dir
    when 1
        if c+3<clen && input[r][c+1] == "M" && input[r][c+2] == "A" && input[r][c+3] == "S"
            val = 1
        end
    when 2
        if c+3<clen && r+3<rlen && input[r+1][c+1] == "M" && input[r+2][c+2] == "A" && input[r+3][c+3] == "S"
            val = 1
        end
    when 3
        if r+3<rlen && input[r+1][c] == "M" && input[r+2][c] == "A" && input[r+3][c] == "S"
            val = 1
        end
    when 4
        if c-3>=0 && r+3<rlen && input[r+1][c-1] == "M" && input[r+2][c-2] == "A" && input[r+3][c-3] == "S"
            val = 1
        end
    when 5
        if c-3 >=0 && input[r][c-1] == "M" && input[r][c-2] == "A" && input[r][c-3] == "S"
            val = 1
        end
    when 6
        if c-3 >=0 && r-3 >=0 && input[r-1][c-1] == "M" && input[r-2][c-2] == "A" && input[r-3][c-3] == "S"
            val = 1
        end
    when 7
        if r-3 >=0 && input[r-1][c] == "M" && input[r-2][c] == "A" && input[r-3][c] == "S"
            val = 1
        end
    when 8
        if r-3 >=0 && c+3<clen && input[r-1][c+1] == "M" && input[r-2][c+2] == "A" && input[r-3][c+3] == "S"
            val = 1
        end
    end

    val
end

def check2(input,r,c,dir)
    val = 0
    rlen = input.length
    clen = input[0].length
    
    # space check is the same for all 4 cases
    if r == rlen-1 || r == 0 || c == clen-1 || c == 0
        return 0
    end

    case dir
    when 1 # Ms on top
        if input[r-1][c-1] == "M" && input[r-1][c+1] == "M" && input[r+1][c+1] == "S" && input[r+1][c-1] == "S"
            val = 1
        end
    when 2 # Ms right
        if input[r-1][c-1] == "S" && input[r-1][c+1] == "M" && input[r+1][c+1] == "M" && input[r+1][c-1] == "S"
            val = 1
        end
    when 3 # Ms on the bottom
        if input[r-1][c-1] == "S" && input[r-1][c+1] == "S" && input[r+1][c+1] == "M" && input[r+1][c-1] == "M"
            val = 1
        end
    when 4 # Ms left
        if input[r-1][c-1] == "M" && input[r-1][c+1] == "S" && input[r+1][c+1] == "S" && input[r+1][c-1] == "M"
            val = 1
        end
    end
    val
end

t1.each_with_index do |row,r|
    row.each_with_index do |char,c|
        if char == "X"
            dirs.each do |dir|
                sum1 += check(t1,r,c,dir)
            end
        end
    end
end
t1.each_with_index do |row,r|
    row.each_with_index do |char,c|
        if char == "A"
            (1..4).each do |dir|
                sum2 += check2(t1,r,c,dir)
            end
        end
    end
end




puts sum1
puts sum2

