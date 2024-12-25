require 'set'
file = "input.txt"

sum1 = 0
sum2 = 0

locks = []
keys = []

lock = []
key = []
mode = ""

File.open(file).each_with_index do |r,i|    
    line = r.strip.split(//)

    if i%8 == 0
        # check if lock or key
        if line[0] == "#" #lock
            mode = "lock"
            lock << line
        else
            mode = "key"
            key << line
        end
    elsif i%8 >= 0 && i%8 <= 6
        if mode =="lock"
            lock << line
        else
            key << line
        end
    else
        if mode == "lock"
            locks << lock
        else
            keys << key
        end
        lock = []
        key = []
        mode =""
        next
    end
end

lockcodes = []
keycodes = []

locks.each do |l|
    lockcode = [-1,-1,-1,-1,-1]
    l.each_with_index do |lr|
        lr.each_with_index do |v,i|
            if v == "#"
                lockcode[i] += 1
            end
        end
    end
    lockcodes << lockcode
end

keys.each do |k|
    keycode = [-1,-1,-1,-1,-1]
    k.each_with_index do |kr| # for each keyrow
        kr.each_with_index do |v,i|
            if v == "#"
                keycode[i] += 1
            end
        end
    end
    keycodes << keycode
end

lockcodes.each do |l|
    keycodes.each do |k|
        fit = true
        5.times do |i|
            if l[i]+k[i] > 5
                fit = false
            end
        end
        if fit == true
            sum1+=1
        end
    end
end

puts sum1