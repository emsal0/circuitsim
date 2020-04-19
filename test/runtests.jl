using Test
using Circuits

@testset "circuits" begin
    c = Circuit()
    register_node!(c, "n1", VoltageSource(5.0))
    register_node!(c, "n2", BaseNode())
    connect_nodes!(c, "n1", "n2", Resistor(5.0))
    connect_nodes!(c, "n2", "GND", Resistor(10.0))
    println(solve_voltages(c))

    c2 = Circuit()
    register_node!(c2, "n1", VoltageSource(12.0))
    register_node!(c2, "n2", BaseNode())
    register_node!(c2, "n3", BaseNode())
    connect_nodes!(c2, "n1", "n2", Resistor(4000.))
    connect_nodes!(c2, "n2", "n3", Resistor(2000.))
    connect_nodes!(c2, "n2", "GND", Resistor(1000.))
    connect_nodes!(c2, "n3", "GND", Resistor(2000.))
    println(solve_voltages(c2))

    c3 = Circuit()
    register_node!(c3, "n1", VoltageSource(5.0))
    register_node!(c3, "n2", BaseNode())
    connect_nodes!(c3, "n1", "n2", Capacitor(10e-6))
    connect_nodes!(c3, "n2", "GND", Resistor(1000.))
    println(solve_voltages(c3))
end
