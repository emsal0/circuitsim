using Test
using Circuits

@testset "circuits" begin
    c = Circuit()
    register_node!(c, "n1", VoltageSource(5.0))
    register_node!(c, "n2", BaseNode())
    connect_nodes!(c, "n1", "n2", Resistor(5.0))
    connect_nodes!(c, "n2", "GND", Resistor(10.0))
    println(solve_voltages(c))
end
