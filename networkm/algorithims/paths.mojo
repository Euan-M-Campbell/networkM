from collections import List, Set
from networkm.graphs import Graph

fn shortest_path( graph: Graph[KeyElement & Stringable], start: KeyElement & Stringable, end: KeyElement & Stringable) -> List[KeyElement & Stringable]:
    visited = Set[KeyElement & Stringable]()
    queue = List[List[KeyElement & Stringable]]()
    start_path = List[KeyElement & Stringable]()
    start_path.append(start)
    queue.append(start_path)
    
    while len(queue) > 0:
        path = queue.pop(0)
        node = path[-1]
        
        if node == end:
            return path
        
        if node not in visited:
            visited.add(node)
            for neighbor_ptr in graph.neighbors(node):
                neighbor = neighbor_ptr[]
                new_path = path.copy()
                new_path.append(neighbor)
                queue.append(new_path)
    
    return List[KeyElement & Stringable]()