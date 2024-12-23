require 'set'
require 'benchmark'
require 'rgl/adjacency'
require 'rgl/dot'
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

triples = Set.new

graph.vertices.combination(3).each do |v|
    a, b, c = v
    if graph.has_edge?(a,b) && graph.has_edge?(b,c) && graph.has_edge?(c,a)
        triples.add(v)
    end
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

k=3
cliques = triples
cliques = cliques.sort

while true
    next_cliques = Set.new

    groups = cliques.group_by { |subarray| subarray[0..-2] }

    groups.each do |common_prefix, subarrays|
        next if subarrays.size < 2
      
        subarrays.combination(2) do |pair|
            if graph.has_edge?(pair[0][-1],pair[1][-1])
                next_cliques.add(pair[0] + [pair[1][-1]])
            end
        end
    end

    if next_cliques.length == 0
        break
    end

    cliques = next_cliques.sort
    k += 1
end

puts cliques[0].sort.join(",")

=begin

def bron_kerbosch(graph, r, p, x, cliques)
    if p.empty? && x.empty?
        cliques << r
        return
    end

    p.dup.each do |v|
        new_r = r + [v]
        new_p = p.select { |u| graph.has_edge?(v, u) }
        new_x = x.select { |u| graph.has_edge?(v, u) }

        bron_kerbosch(graph, new_r, new_p, new_x, cliques)

        p.delete(v)
        x << v
    end
end
  
def find_cliques(graph)
    cliques = []
    vertices = graph.vertices.to_a

    bron_kerbosch(graph, [], vertices, [], cliques)

    cliques
end

max_cliques = find_cliques(graph)

max = max_cliques.max_by(&:length)

puts max.sort.join(",")

#graph.write_to_graphic_file('jpg', 'graph_'+file)
=end