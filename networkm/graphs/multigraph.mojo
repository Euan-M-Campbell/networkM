from collections import Dict

# TODO
struct MultiGraph[T: KeyElement]:
    var nodes: Dict[T, Dict[String, String]]
    var edges: List[(T, T)]
    var frozen: Bool