require 'set'
require 'benchmark'
file = "input.txt"

sum1 = 0
sum2 = 0

codes = []

paths_keypad = {"7"=>{"8"=>[">"], "9"=>[">>"], "4"=>["v"], "5"=>["v>",">v"], "6"=>["v>>",">>v"], "1"=>["vv"], "2"=>["vv>",">vv"], "3"=>["vv>>",">>vv"], "0"=>[">vvv"], "A"=>[">>vvv"]}, "8"=>{"7"=>["<"], "9"=>[">"], "4"=>["<v","v<"], "5"=>["v"], "6"=>["v>",">v"], "1"=>["<vv","vv<"], "2"=>["vv"], "3"=>["vv>",">vv"], "0"=>["vvv"], "A"=>["vvv>",">vvv"]}, "9"=>{"7"=>["<<"], "8"=>["<"], "4"=>["<<v","v<<"], "5"=>["v<","<v"], "6"=>["v"], "1"=>["<<vv","vv<<"], "2"=>["<vv","vv<"], "3"=>["vv"], "0"=>["<vvv","vvv<"], "A"=>["vvv"]}, "4"=>{"7"=>["^"], "8"=>["^>",">^"], "9"=>["^>>",">>^"], "5"=>[">"], "6"=>[">>"], "1"=>["v"], "2"=>["v>",">v"], "3"=>["v>>",">>v"], "0"=>[">vv"], "A"=>[">>vv"]}, "5"=>{"7"=>["<^","^<"], "8"=>["^"], "9"=>["^>",">^"], "4"=>["<"], "6"=>[">"], "1"=>["<v","v<"], "2"=>["v"], "3"=>["v>",">v"], "0"=>["vv"], "A"=>["vv>",">vv"]}, "6"=>{"7"=>["<<^","^<<"], "8"=>["<^","^<"], "9"=>["^"], "4"=>["<<"], "5"=>["<"], "1"=>["<<v","v<<"], "2"=>["<v","v<"], "3"=>["v"], "0"=>["<vv","vv<"], "A"=>["vv"]}, "1"=>{"7"=>["^^"], "8"=>["^^>",">^^"], "9"=>["^^>>",">>^^"], "4"=>["^"], "5"=>["^>",">^"], "6"=>["^>>",">>^"], "2"=>[">"], "3"=>[">>"], "0"=>[">v"], "A"=>[">>v"]}, "2"=>{"7"=>["<^^","^^<"], "8"=>["^^"], "9"=>["^^>",">^^"], "4"=>["<^","^<"], "5"=>["^"], "6"=>["^>",">^"], "1"=>["<"], "3"=>[">"], "0"=>["v"], "A"=>["v>",">v"]}, "3"=>{"7"=>["<<^^","^^<<"], "8"=>["<^^","^^<"], "9"=>["^^"], "4"=>["<<^","^<<"], "5"=>["<^","^<"], "6"=>["^"], "1"=>["<<"], "2"=>["<"], "0"=>["<v","v<"], "A"=>["v"]}, "0"=>{"7"=>["^^^<"], "8"=>["^^^"], "9"=>["^^^>",">^^^"], "4"=>["^^<"], "5"=>["^^"], "6"=>["^^>",">^^"], "1"=>["^<"], "2"=>["^"], "3"=>["^>",">^"], "A"=>[">"]}, "A"=>{"7"=>["^^^<<"], "8"=>["<^^^","^^^<"], "9"=>["^^^"], "4"=>["^^<<"], "5"=>["<^^","^^<"], "6"=>["^^"], "1"=>["^<<"], "2"=>["<^","^<"], "3"=>["^"], "0"=>["<"]}}
#paths_keypad = {"7"=>{"8"=>">", "9"=>">>", "4"=>"v", "5"=>"v>", "6"=>"v>>", "1"=>"vv", "2"=>"vv>", "3"=>"vv>>", "0"=>"vvv>", "A"=>"vvv>>"}, "8"=>{"7"=>"<", "9"=>">", "4"=>"v<", "5"=>"v", "6"=>"v>", "1"=>"vv<", "2"=>"vv", "3"=>"vv>", "0"=>"vvv", "A"=>"vvv>"}, "9"=>{"7"=>"<<", "8"=>"<", "4"=>"v<<", "5"=>"v<", "6"=>"v", "1"=>"vv<<", "2"=>"vv<", "3"=>"vv", "0"=>"vvv<", "A"=>"vvv"}, "4"=>{"7"=>"^", "8"=>"^>", "9"=>"^>>", "5"=>">", "6"=>">>", "1"=>"v", "2"=>"v>", "3"=>"v>>", "0"=>"vv>", "A"=>"vv>>"}, "5"=>{"7"=>"^<", "8"=>"^", "9"=>"^>", "4"=>"<", "6"=>">", "1"=>"v<", "2"=>"v", "3"=>"v>", "0"=>"vv", "A"=>"vv>"}, "6"=>{"7"=>"^<<", "8"=>"^<", "9"=>"^", "4"=>"<<", "5"=>"<", "1"=>"v<<", "2"=>"v<", "3"=>"v", "0"=>"vv<", "A"=>"vv"}, "1"=>{"7"=>"^^", "8"=>"^^>", "9"=>"^^>>", "4"=>"^", "5"=>"^>", "6"=>"^>>", "2"=>">", "3"=>">>", "0"=>"v>", "A"=>"v>>"}, "2"=>{"7"=>"^^<", "8"=>"^^", "9"=>"^^>", "4"=>"^<", "5"=>"^", "6"=>"^>", "1"=>"<", "3"=>">", "0"=>"v", "A"=>"v>"}, "3"=>{"7"=>"^^<<", "8"=>"^^<", "9"=>"^^", "4"=>"^<<", "5"=>"^<", "6"=>"^", "1"=>"<<", "2"=>"<", "0"=>"v<", "A"=>"v"}, "0"=>{"7"=>"^^^<", "8"=>"^^^", "9"=>"^^^>", "4"=>"^^<", "5"=>"^^", "6"=>"^^>", "1"=>"^<", "2"=>"^", "3"=>"^>", "A"=>">"}, "A"=>{"7"=>"^^^<<", "8"=>"^^^<", "9"=>"^^^", "4"=>"^^<<", "5"=>"^^<", "6"=>"^^", "1"=>"^<<", "2"=>"^<", "3"=>"^", "0"=>"<"}}
paths_dirpad = {"^"=>{"A"=>[">"], "<"=>["v<"], "v"=>["v"], ">"=>["v>",">v"]}, "A"=>{"^"=>["<"], "<"=>["v<<"], "v"=>["<v","v<"], ">"=>["v"]}, "<"=>{"^"=>[">^"], "A"=>[">>^"], "v"=>[">"], ">"=>[">>"]}, "v"=>{"^"=>["^"], "A"=>["^>",">^"], "<"=>["<"], ">"=>[">"]}, ">"=>{"^"=>["<^","^<"], "A"=>["^"], "<"=>["<<"], "v"=>["<"]}}
#paths_dirpad = {"^"=>{"A"=>">", "<"=>"v<", "v"=>"v", ">"=>"v>"}, "A"=>{"^"=>"<", "<"=>"v<<", "v"=>"v<", ">"=>"v"}, "<"=>{"^"=>"^>", "A"=>"^>>", "v"=>">", ">"=>">>"}, "v"=>{"^"=>"^", "A"=>"^>", "<"=>"<", ">"=>">"}, ">"=>{"^"=>"^<", "A"=>"^", "<"=>"<<", "v"=>"<"}}
File.open(file).each_with_index do |r,y|
    r = r.strip.split(//)
    codes << r
end

def navigate_on_keypad(code, paths)
    output = []
    last_key = "A"
    code.each do |c|
        #puts "Doing "+last_key+" -> "+c
        if last_key != c
            if paths[last_key][c].length > 1
                #puts "Options are:"
                #puts paths[last_key][c].join(", ")
                if paths[last_key][c][1][0] == last_key
                    output << paths[last_key][c][1]
                else 
                    output << paths[last_key][c][0]
                end
            else
                output << paths[last_key][c][0]
            end
        end
        output << "A"
        #puts output.join("")
        last_key = c
    end
    output
end

codes.each do |c|
    nr = c[0..-2].join("").to_i
    puts c.join("")
    path_keypad = navigate_on_keypad(c, paths_keypad).join("").split(//)  
    puts navigate_on_keypad(c, paths_keypad).join("  ")

    path_numpad = []
    2.times do |i|
        path_numpad = navigate_on_keypad(path_keypad, paths_dirpad).join("").split(//)  
        path_keypad = path_numpad
    end

    len = path_numpad.length
    puts len
    sum1 += nr *len
end

puts sum1

