fn hash_tuple[T: KeyElement](t: (T, T)) -> UInt:
    return hash(t[0])*31 ^ hash(t[1])