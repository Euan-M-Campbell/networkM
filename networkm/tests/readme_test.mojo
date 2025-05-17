from networkm.graphs import Graph

fn test_readme():

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

    print("Adding Edges and Nodes from other Graphs")
    var graph_1: Graph[Int] = Graph[Int](List(1, 2), List((1, 2)))
    var graph_2: Graph[Int] = Graph[Int]()

    graph_2.add_nodes_from(graph_1)
    graph_2.add_edges_from(graph_1)
    print(graph_1)
    print(graph_2)