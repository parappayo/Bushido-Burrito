# xform.py (Matt Olson)

# Transformation stuff (3x3 matrices, really)
# Vector stuff (3-component homogeneous) 

import math
class Vector:
    def __init__(self, v):
        self.v = v

    def tuple(self): return self.v

    def comp(self, which): return self.v[which]

    def pos(self): return self.v[0:2]

    def is_vec(self): return self.v[2] == 0

    def is_pt(self): return self.v[2] == 1

    def dprod(self, other):
        u = self.v
        v = other.v # FIXME: better names
        return u[0]*v[0] + u[1]*v[1]

    def dp3(self, other):
        u = self.v
        v = other.v
        return u[0]*v[0] + u[1]*v[1] + u[2]*v[2]

    def xprod(self, other):
        # Since we're dealing with two dimensions, the cross product of
        # two vectors is a scalar, rather than a third vector (which has
        # no way to be orthogonal to both inputs)
        u = self.v
        v = other.v
        return u[0]*v[1] - u[1]*v[0]

    def sqlen(self):
        return self.dprod(self)

    def len(self): return math.sqrt(self.sqlen())

    def show(self):
        print("%4.4f %4.4f %4.4f" % (self.v[0], self.v[1], self.v[2]))


# vec.point and vec.vector return new objects of class Vector; the
# difference is that a point will have w=1 (can be translated), and a
# vector will have w=0.

# XXX: need a better name for the module and class?

def point(x, y): return Vector((x,y,1))

def vector(x, y): return Vector((x,y,0))


# Vector-valued expressions are separate from the Vector class, to
# emphasize the fact that Vectors are value objects

def scale(U, x):
    u = U.pos()
    if U.is_vec():
        return vector(u[0] * x, u[1] * x)
    else:
        return point(u[0] * x, u[1] * x)

def add(U, V):
    u = U.pos()
    v = V.pos()
    if U.is_vec() and V.is_vec():
        return vector(u[0] + v[0], u[1] + v[1])
    else:
        return point(u[0] + v[0], u[1] + v[1])

def sub(U, V):
    return add(U, scale(V, -1))

def interp(U, V, t):
    return add(scale(U, 1.0-t), scale(V, t))

def norm(U):
    return scale(U, 1.0/U.len())

class Xform:
    def __init__(self, c0, c1, c2):
        self.cols = (c0, c1, c2)

    def show(self):
        self.row(0).show()
        self.row(1).show()
        self.row(2).show()

    def col(self, which):
        return self.cols[which]

    def row(self, which):
        return Vector((self.cols[0].comp(which),
                       self.cols[1].comp(which),
                       self.cols[2].comp(which)))

    def xform(self, V):
        return Vector((V.dp3(self.row(0)),
                       V.dp3(self.row(1)),
                       V.dp3(self.row(2))))

    def mult(self, M):
        return Xform(self.xform(M.col(0)),
                     self.xform(M.col(1)),
                     self.xform(M.col(2)))

def identity():
    return Xform(vector(1,0), vector(0,1), point(0,0))

def translation(x, y):
    return Xform(vector(1,0), vector(0,1), point(x, y))

def rotation(theta):
    c = math.cos(theta)
    s = math.sin(theta)
    return Xform(vector(c,s), vector(-s,c), point(0,0))

def scale(factor):
    return Xform(vector(factor,0), vector(0,factor), point(0,0))

