module Circuits

export Circuit, Node, traverse

# Node
abstract type Node end
abstract type Connection end
Edge = Tuple{Node, Connection}

mutable struct BaseNode <: Node
    neighbors::Set{Edge}
    function BaseNode()
        return BaseNode(neighbors = Set{NamedTuple{(:dest, :resistance), 
                                        Tuple{Node,AbstractFloat}}}())  
    end
end

mutable struct VoltageSource <: Node
    added_voltage::AbstractFloat
    neighbors::Set{Edge}
    function VoltageSource(added_voltage)
        added_voltage = added_voltage
        new(added_voltage, Set())
    end
end

neighbors(n::Node) = function(n)
    if (isdefined(n, :neighbors))
        return n.neighbors
    else
        throw(ArgumentError("Node does not have a well-defined neighbor set"))
    end
end


# Connection

mutable struct Resistor <: Connection
    resistance::AbstractFloat # in ohms
end

function traverse(root::Node)
    visited = Set()
    queue = [root]
    while length(queue) > 0
        cur = popfirst!(queue)
        for edge in neighbors(cur)
            println("The type of this edge is $(typeof(edge))")
            if !in(edge.dest, visited)
                push!(queue, edge.dest)
            end
        end
        push!(visited, cur)
    end
end


# Circuit
mutable struct Circuit
    ground::Node

    nodes::Dict{String, Node}

    function Circuit()
        ground = VoltageSource(0)
        nodes = Dict()
        get!(nodes, "GND", ground)
        ground.added_voltage = 0
        return new(ground, nodes)
    end
end

function verify_circuit(c::Circuit)
    return false
end

function register_node!(c::Circuit, name::String, n::Node)
    return get!(c.nodes, name, n) == n
end

function get_node(c::Circuit, name::String)
    return c.nodes[name]
end

function connect_nodes!(c::Circuit, name1, name2::String, c::Connection)
    n1 = c.nodes[name1]
    n2 = c.nodes[name2]
    e1 = (n2, c)
    e2 = (n1, c)
    push!(n1.neighbors, e1)
    push!(n2.neighbors, e2)
end

function solve_voltages(c::Circuit)
    return []
end

end # module
