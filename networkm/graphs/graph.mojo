from collections import Dict, List

@value
struct Node[T: KeyElement & Stringable](Stringable, Writable):
    
    var id: T
    var attr: Dict[String, String]

    fn __init__(out self, id: T, attributes: Dict[String, String]):
        self.id = id
        self.attr = attributes

    fn __str__(self) -> String:
        return String(self.id)

    fn write_to[W: Writer](self, mut writer: W):
        writer.write(String(self.id) + "\n")
        for key in self.attr.keys():
            writer.write(String(key) + "\n")

@value
struct Edge[T: KeyElement & Stringable](Stringable, Writable):
    
    var nodes: (T, T)
    var weight: Float64
    var attr: Dict[String, String]

    fn __init__(out self, nodes: (T, T), weight: Float64, attributes: Dict[String, String]):
        self.nodes = nodes
        self.weight = weight
        self.attr = attributes

    fn __str__(self) -> String:
        return String(self.nodes[0]) + "-" + String(self.nodes[1]) + " (" + String(self.weight) + ")"

    fn write_to[W: Writer](self, mut writer: W):
        writer.write(String(self.nodes[0]) + "-" + String(self.nodes[1]) + " (" + String(self.weight) + ")\n")
        for key in self.attr.keys():
            writer.write(String(key) +  "\n")


fn hash_tuple[T: KeyElement](t: (T, T)) -> UInt:
    return hash(t[0])*31 ^ hash(t[1])

struct Graph[T: KeyElement & Stringable](StringableRaising):

    var _nodes: Dict[T, Node[T]]
    var _edges: Dict[UInt, Edge[T]]
    var _adj: Dict[T, Dict[T, UInt]]
    var _frozen: Bool

    fn __init__(out self):
        self._nodes = Dict[T, Node[T]]()
        self._edges = Dict[UInt, Edge[T]]()
        self._adj = Dict[T, Dict[T, UInt]]()
        self._frozen = False

    fn __init__(out self, nodes: List[T], edges: List[(T, T)]):
        self._nodes = Dict[T, Node[T]]()
        self._edges = Dict[UInt, Edge[T]]()
        self._adj = Dict[T, Dict[T, UInt]]()
        self._frozen = False
        
        for n_ptr in nodes:
            node = n_ptr[]
            self.add_node(node, Dict[String, String]())

        for e_ptr in edges:
            edge = e_ptr[]
            self.add_edge(edge[0], edge[1], 1.0, Dict[String, String]())

    fn add_node(mut self, node: T) -> None:
        if node not in self._nodes:
            self._nodes[node] = Node[T](node, Dict[String, String]())
            self._adj[node] = Dict[T, UInt]()

    fn add_node(mut self, node: T, attr: Dict[String, String]) -> None:
        self._nodes[node] = Node[T](node, attr)
        self._adj[node] = Dict[T, UInt]()

    fn add_edge(mut self, node1: T, node2: T) -> None:
        h = hash_tuple[T]((node1, node2))
        if h not in self._edges:
            self._edges[h] = Edge[T]((node1, node2), 1.0, Dict[String, String]())

        if node1 not in self._nodes:
            self.add_node(node1, Dict[String, String]())

        if node2 not in self._nodes:
            self.add_node(node2, Dict[String, String]())

        try:
            self._adj[node1][node2] = h
            self._adj[node2][node1] = h
        except KeyError:
            print("NetworkM Error - add_node")

    fn add_edge(mut self, node1: T, node2: T, weight: Float64, attr: Dict[String, String]) -> None:
        h = hash_tuple[T]((node1, node2))
        self._edges[h] = Edge[T]((node1, node2), weight, attr)

        if node1 not in self._nodes:
            self.add_node(node1, Dict[String, String]())

        if node2 not in self._nodes:
            self.add_node(node2, Dict[String, String]())

        try:
            self._adj[node1][node2] = h
            self._adj[node2][node1] = h
        except KeyError:
            print("NetworkM Error - add_edge")

    fn add_nodes_from(mut self, nodes: List[T]) -> None:
        for n_ptr in nodes:
            node = n_ptr[]
            self.add_node(node, Dict[String, String]())

    fn add_nodes_from(mut self, nodes: List[(T, Dict[String, String])]) -> None:
        for n_ptr in nodes:
            node_data = n_ptr[]
            node = node_data[0]
            node_attributes = node_data[1]
            self.add_node(node, node_attributes)

    fn add_nodes_from(mut self, graph: Graph[T]) -> None:
        for n_ptr in graph.nodes():
            node = n_ptr[]
            self.add_node(node, Dict[String, String]())

    fn add_edges_from(mut self, edges: List[(T, T)]) -> None:
        for e_ptr in edges:
            edge = e_ptr[]
            self.add_edge(edge[0], edge[1], 1.0, Dict[String, String]())

    fn add_edges_from(mut self, edges: List[(T, T, Float64, Dict[String, String])]) -> None:
        for e_ptr in edges:
            edge = e_ptr[]
            self.add_edge(edge[0], edge[1], edge[2], edge[3])

    fn add_edges_from(mut self, graph: Graph[T]) -> None:
        for e_ptr in graph.edges():
            edge = e_ptr[]
            self.add_edge(edge[0], edge[1], 1.0, Dict[String, String]())

    fn remove_node(mut self, node: T) -> None:
        try:
            self.remove_edges_from_node(node)
            _ = self._nodes.pop(node)
            _ = self._adj.pop(node)
        except:
            print("NetworkM Error - remove_node")

    fn remove_nodes_from(mut self, nodes: List[T]) -> None:
        for n_ptr in nodes:
            node = n_ptr[]
            self.remove_node(node)

    fn remove_edge(mut self, node1: T, node2: T) -> None:
        h = hash_tuple[T]((node1, node2))
        try:
            _ = self._edges.pop(h)
            _ = self._adj[node1].pop(node2)
            _ = self._adj[node2].pop(node1)
        except KeyError:
            print("NetworkM Error - remove_edge")

    fn remove_edges_from(mut self, edges: List[(T, T)]) -> None:
        for e_ptr in edges:
            edge = e_ptr[]
            self.remove_edge(edge[0], edge[1])

    fn remove_edges_from_node(mut self, node: T) -> None:
        try:
            connected_nodes = self._adj[node].keys()
            for n_ptr in connected_nodes:
                n = n_ptr[]
                self.remove_edge(node, n)
        except:
            print("NetworkM Error - remove_edges_from_node")

    fn clear(mut self) -> None:
        self._nodes = Dict[T, Node[T]]()
        self._edges = Dict[UInt, Edge[T]]()
        self._adj = Dict[T, Dict[T, UInt]]()

    fn freeze(mut self) -> None:
        self._frozen = True

    fn nodes(self) -> List[T]:
        var nodes = List[T]()
        for n_ptr in self._nodes.keys():
            node = n_ptr[]
            nodes.append(node)
        return nodes

    fn edges(self) -> List[(T, T)]:
        try:
            var edges = List[(T, T)]()
            for e_ptr in self._edges.keys():
                edge = e_ptr[]
                node1 = self._edges[edge].nodes[0]
                node2 = self._edges[edge].nodes[1]
                edges.append((node1, node2))
            return edges
        except KeyError:
            print("NetworkM Error - edges")
            return List[(T, T)]()

    fn number_of_nodes(self) -> Int:
        return len(self._nodes)

    fn number_of_edges(self) -> Int:
        return len(self._edges)

    fn has_node(self, node: T) -> Bool:
        return node in self._nodes

    fn has_edge(self, edge: (T, T)) -> Bool:
        return edge in self

    fn degree(self, node: T) -> Int:
        try:
            return len(self._adj[node])
        except KeyError:
            print("NetworkM Error - degree")
            return 0

    fn neighbors(self, node: T) -> List[T]:
        try:
            neighbors = List[T]()
            for n_ptr in self._adj[node].keys():
                neighbors.append(n_ptr[])
            return neighbors
        except KeyError:
            print("NetworkM Error - neighbors")
            return List[T]()

    fn adj(self, node: T) -> List[(T, T)]:
        return List[Tuple[T, T]]()

    fn get_edge_data(self, node1: T, node2: T) -> Dict[String, String]:
        try:
            return self._edges[self._adj[node1][node2]].attr
        except KeyError:
            print("NetworkM Error - get_edge_data")
            return Dict[String, String]()

    # TODO: Implement __getitem__ and __setitem__ methods
    # fn __getitem__(self, node: T) raises -> Node[T]:
    #     try:
    #         return self._adj[node]
    #     except KeyError:
    #         print("NetworkM Error - __getitem__")
    #         raise KeyError

    # fn __getitem__(self, node1: T, node2: T) raises -> Edge[T]:
    #     try:
    #         return self._edges[self._adj[node1][node2]]
    #     except KeyError:
    #         print("NetworkM Error - __getitem__")
    #         raise KeyError

    # fn __setitem__(mut self, node: T, attr: Dict[String, String]) raises -> None:
    #     try:
    #         if node in self._nodes:
    #             self._nodes[node].attr = attr
    #         else:
    #             self.add_node(node, attr)
    #     except KeyError:
    #         print("NetworkM Error - __setitem__")
    #         raise KeyError

    fn __len__(self) -> Int:
        return len(self._nodes)

    fn __contains__(self, node: T) -> Bool:
        return node in self._nodes

    fn __contains__(self, edge: (T, T)) -> Bool:
        h = hash_tuple[T](edge)
        return h in self._edges

    def __str__(self) -> String:
        return "Graph with " + String(self.number_of_nodes()) + " nodes and " + String(self.number_of_edges()) + " edges"

    fn write_to[W: Writer](self, mut writer: W):
        writer.write("Graph with " + String(self.number_of_nodes()) + " nodes and " + String(self.number_of_edges()) + " edges\n")
        writer.write("\nNodes:\n")
        for ptr in self._nodes.keys():
            node = ptr[]
            writer.write(String(node))
            writer.write("\n")
        writer.write("\nEdges:\n")
        for e_ptr in self.edges():
            edge = e_ptr[]
            writer.write(String(edge[0]) + "-" + String(edge[1]))
            writer.write("\n")
        writer.write("\n")

    