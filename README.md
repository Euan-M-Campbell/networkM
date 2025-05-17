# NetworkM

NetworkM is a Mojo package for the creation, manipulation and use of networks, inspired by Python's NetworkX Package.

# Usage

## Creating Graphs

Graphs are initalized with a single node type. The type used for nodes in a graph must implement the KeyElement trait.  
```mojo
var graph: Graph[Int] = Graph[Int]()
```

Graphs can be initalized with nodes and edges.
```mojo
var nodes: List[String] = List[String](String("A"), String("B"), String("C"))
var edges: List[(String, String)] = List[(String, String)]((String("A"), String("B")), (String("B"), String("C")))

var graph: Graph[String] = Graph[String](nodes, edges)
```

## Manipulating Graphs

### Adding Nodes & Edges

Nodes can be added to graphs individually or in a list
```mojo
graph.add_node(1)
graph.add_nodes_from(List(2, 3, 4, 5, 6, 7, 8, 9, 10))
```

Edges can be added to graphs individually or in a list.
```mojo
graph.add_edge(1, 2)
graph.add_edges_from(List((3, 4), (4, 5), (5, 6), (6, 7), (7, 8), (8, 9), (9, 10)))
```

Nodes and edges can be added from one graph to another graph of the same type.
```mojo
var graph_1: Graph[Int] = Graph[Int](List(1, 2), List((1, 2)))
var graph_2: Graph[Int] = Graph[Int]()

graph_2.add_nodes_from(graph_1)
graph_2.add_edges_from(graph_1)
```

### Removing Nodes & Edges

Individual or lists of nodes can be removed from a graph. Removing a node also removes any edges with the node.
```mojo
graph.remove_node(1)
graph.remove_nodes_from(List(2, 3, 4))
```

Individual or lists of edges can be removed from a graph.
```mojo
graph.remove_edge(5, 6)
graph.remove_edges_from(List((6, 7), (7, 8)))
```

Graphs can be cleared, removing all nodes and edges.
```mojo
graph.clear()
```

## Graph Generators

Graph generator functions can be used to create graphs in a pre-defined structure

path_graph() creates a graph with a single line of nodes, each conntect to two other nodes, except from the first and last node.
```mojo
var graph: Graph[Int] = path_graph(10)
```

Generators include:
- path_graph : Creates a linear chain of nodes where each node is connected to its immediate neighbor.
- cycle_graph : Creates a circular graph where each node is connected to two neighbors, forming a closed loop.
- complete_graph : Creates a fully connected graph where every node is connected to every other node.

## Graph Algorithims

Graph algorithims can be used to analyse graphs and identify paths

shortest_path returns the shortest path between two nodes
```mojo
var graph: Graph[String] = Graph[String]()
var path: List[String] = shortest_path(graph, source=String(A), target=String(Z))
```

