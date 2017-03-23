
Graph Edit Tool

The idea here is to write a simple nodes and edges style graph editor that makes few assumptions about its intended use.

Nodes are positioned on a grid with arrows drawn between them to represent the edges.

Graphes may be saved and loaded as json data.

Each node has the following properties:

- name (string)
- body (string)
- edges (list of edge objects)

Each edge has the following properties:

- from (node object)
- to (node object)
- bidirectional (boolean)
