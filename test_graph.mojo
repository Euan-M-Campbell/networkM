from collections import Dict
from networkm.graphs.graph import Graph
# from networkm.graphs.graph2 import Graph2
# from networkm.generators.functions import path_graph

fn main():

    print("Creating Graph")
    var graph: Graph[Int] = Graph[Int]()
    print(graph)

    print("Adding Nodes")
    graph.add_node(1)
    graph.add_nodes_from(List(2, 3, 4, 5, 6, 7, 8, 9, 10))
    print(graph)

    print("Adding Edges")
    graph.add_edge(1, 2)
    graph.add_edges_from(List((3, 4), (4, 5), (5, 6), (6, 7), (7, 8), (8, 9), (9, 10)))
    print(graph)

    print("Removing Nodes")
    graph.remove_node(1)
    graph.remove_nodes_from(List(2, 3, 4))
    print(graph)

    print("Removing Edges")
    graph.remove_edge(5, 6)
    graph.remove_edges_from(List((6, 7), (7, 8)))
    print(graph)

    print("Clearing Graph")
    graph.clear()
    print(graph)

