require 'set'
require 'rgl/adjacency'
file = "input.txt"

sum1 = 0
sum2 = 0

pairs = []

File.open(file).each_with_index do |r,y|
    r = r.strip.split("-")
    pairs << r
end

graph = RGL::AdjacencyGraph.new

pairs.each do |p|
    graph.add_edge(p[0],p[1])
end

k=2
cliques = graph.edges.map { |edge| [edge.source, edge.target] }.sort
triples = []

while true
    next_cliques = Set.new

    if k == 3
        triples = cliques
    end

    groups = cliques.group_by { |subarray| subarray[0..-2] }
    groups.each do |common_prefix, subarrays|
        next if subarrays.size < 2
      
        subarrays.combination(2) do |pair|
            if graph.has_edge?(pair[0][-1],pair[1][-1])
                next_cliques.add((pair[0] + [pair[1][-1]]).sort)
            end
        end
    end

    if next_cliques.length == 0
        break
    end

    cliques = next_cliques.sort
    k += 1
end

good_triples = []

triples.each do |t|
    t.each do |v|
        if v[0] == "t"
            good_triples << t
            break
        end
    end
end

sum1 = good_triples.length
puts sum1

puts cliques[0].sort.join(",")