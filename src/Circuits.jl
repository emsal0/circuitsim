using LinearAlgebra

module Circuits

export Circuit, Node, BaseNode, VoltageSource, traverse, Edge
export Connection, Resistor, EmptyWire
export register_node!, connect_nodes!, solve_voltages

const DEBUG = true

# Node
abstract type Node end
abstract type Connection end
Edge = Tuple{String, String, Connection}

mutable struct BaseNode <: Node end

mutable struct VoltageSource <: Node
    added_voltage::AbstractFloat
end


# Connection

struct EmptyWire <: Connection end

mutable struct Resistor <: Connection
    resistance::AbstractFloat # in ohms
end

mutable struct Capacitor <: Connection
    capacitance::AbstractFloat # in ohms
end

mutable struct Inductor <: Connection
    inductance::AbstractFloat # in ohms
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
    edges::Array{Edge}

    function Circuit()
        ground = BaseNode()
        nodes = Dict()
        get!(nodes, "GND", ground)
        edges = []
        return new(ground, nodes, edges)
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

function connect_nodes!(c::Circuit, name1, name2::String, con::Connection)
    e = (name1, name2, con)
    push!(c.edges, e)
end

function update_rows!(S::Array{T, 2}, c, i, j, node1, node2, R) where {T <: Real}
    if !isa(node1, VoltageSource) && node1 != c.ground
        S[i, i] += 1 / R
        S[i, j] += -1 / R
    end
end

function update_soln_matx!(con::Connection, c, node_to_idx, S)
    throw(ArgumentError("Connection type not supported yet."))
end

function update_soln_matx!(con::Resistor, c, name1, name2, node_to_idx, S)
    node1 = c.nodes[name1]
    node2 = c.nodes[name2]
    i = node_to_idx[name1]
    j = node_to_idx[name2]
    R = con.resistance
    update_rows!(S, c, i, j, node1, node2, R)
    update_rows!(S, c, j, i, node2, node1, R)
end

function solve_voltages(c::Circuit)
    names = [n[1] for n in collect(c.nodes)]
    node_to_idx = Dict([name => i for (i, name) in enumerate(names)])
    N = length(c.nodes)
    S = zeros(N, N)
    b = zeros(N, 1)

    z = node_to_idx["GND"]
    S[z,z] = 1

    for (name, node) in c.nodes
        if node isa VoltageSource
            i = node_to_idx[name]
            S[i, i] = 1
            b[i] = node.added_voltage
        end
    end

    for (name1, name2, con) in c.edges
        update_soln_matx!(con, c, name1, name2, node_to_idx, S)
    end

    if DEBUG
        println(S)
        println(b)
    end
    return inv(S) * b
end

end # module
