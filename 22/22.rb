require 'set'
require 'benchmark'
file = "input.txt"

sum1 = 0
sum2 = 0

codes = []

$nrs = Hash.new
$patterns = Hash.new

File.open(file).each_with_index do |r,y|
    r = r.strip()
    codes << r.to_i
end

def pat_to_int(pat)
    nr1 = pat[0]+9
    nr2 = pat[1]+9
    nr3 = pat[2]+9
    nr4 = pat[3]+9

    res = (((nr1 << 5) | nr2) << 5 | nr3) << 5 | nr4
    res
end    

def mix(secret, nr)
    secret ^ nr
end

def prune(nr)
    nr % 16777216
end

def calc(nr, i)
    beginning = nr

    secret = nr

    nrs = [beginning%10]

    i.times do 
        nr = nr*64

        secret = mix(secret, nr)
        secret = prune(secret)

        nr = (secret / 32).round

        secret = mix(secret, nr)
        secret = prune(secret)

        nr = secret*2048
        secret = mix(secret, nr)
        secret = prune(secret)

        nr = secret
        #print nr%10
        nrs << nr%10
    end
    $nrs[beginning] = nrs
    return secret
end

codes.each do |c|
    res = calc(c,2000)
    sum1+=res
end

puts sum1

i = 0
len = $nrs.length
$nrs.each do |k,v|
    #puts "#{i} / #{len}"
    p2 = Hash.new
    v.each_with_index do |x,i|
        next if i<4
        pat = [v[i-3]-v[i-4],v[i-2]-v[i-3],v[i-1]-v[i-2],x-v[i-1]]
        key = pat_to_int(pat)
        p2[key] = x if !p2.key?(key)
    end
    $patterns[k] = p2
    i+=1
end

#puts "flattening"
unique_pats = $patterns.values.flat_map(&:keys).uniq

len = unique_pats.length
unique_pats.each_with_index do |pat,i|
    #puts "#{i} / #{len}"
    res = 0
    $patterns.each do |k,v| # k is a starting number, v is a hash of patterns and their vals
        if v.key?(pat)
            res+=v[pat]
        end
    end
    if res > sum2
        sum2 = res
    end
end
puts sum2