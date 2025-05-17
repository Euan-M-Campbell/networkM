from networkm.graphs import Graph

fn path_graph(n: Int) -> Graph[Int]:

    nodes = List[Int]()
    edges = List[(Int, Int)]()
    for i in range(0, n):
        nodes.append(i)
        if i > 0:
            edges.append((i - 1, i))

    return Graph[Int](nodes, edges)

fn cycle_graph(n: Int) -> Graph[Int]:
    nodes = List[Int]()
    edges = List[(Int, Int)]()

    for i in range(0, n):
        nodes.append(i)
        edges.append((i, (i + 1) % n))

    return Graph[Int](nodes, edges)

fn complete_graph(n: Int) -> Graph[Int]:
    nodes = List[Int]()
    edges = List[(Int, Int)]()

    for i in range(0, n):
        nodes.append(i)
        for j in range(i + 1, n):
            edges.append((i, j))

    return Graph[Int](nodes, edges)