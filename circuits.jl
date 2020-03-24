module Circuits

export Circuit, Node, traverse

mutable struct Node
    added_voltage::Float64
    neighbors::Set{NamedTuple{(:dest, :resistance), Tuple{Node,Float64}}}
    Node() = new()
end

function traverse(root::Node)
    visited = Set()
    queue = [root]
    while length(queue) > 0
        cur = popfirst!(queue) 
        for edge in cur.neighbors
            println("The resistance of this edge is $(edge.resistance)")
            if !in(edge.dest, visited)
                push!(queue, edge.dest)
            end
        end
        push!(visited, cur)
    end
end



mutable struct Circuit
    ground::Node

    nodes::Array{Node}
    
    function Circuit() 
        ground = Node()
        push!(nodes, ground)
        ground.voltage = 0
    end
end

function register_node(c::Circuit, n::Node)
    push!(c.nodes, n)
end

function solve_voltages(c::Circuit)
    []
end

end

"""
m = Circuits.Node()
n = Circuits.Node()
m.neighbors = [(dest=n, resistance=4)]
n.neighbors = [(dest=m, resistance=5)]
"""
