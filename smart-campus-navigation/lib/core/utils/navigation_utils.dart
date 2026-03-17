import 'dart:collection';
import 'dart:math';

/// A simple graph node representing a navigable point on a floor plan.
class NavNode {
  const NavNode({required this.id, required this.lng, required this.lat});
  final String id;
  final double lng;
  final double lat;
}

/// A weighted undirected edge between two [NavNode]s.
class NavEdge {
  const NavEdge({required this.from, required this.to, required this.weight});
  final String from;
  final String to;
  final double weight; // distance in metres
}

class NavigationUtils {
  NavigationUtils._();

  /// Dijkstra's shortest-path algorithm on an indoor navigation graph.
  ///
  /// Returns an ordered list of node IDs representing the shortest path
  /// from [startId] to [endId], or an empty list if no path exists.
  static List<String> dijkstra({
    required List<NavNode> nodes,
    required List<NavEdge> edges,
    required String startId,
    required String endId,
  }) {
    // Build adjacency map
    final adjacency = <String, List<NavEdge>>{};
    for (final node in nodes) {
      adjacency[node.id] = [];
    }
    for (final edge in edges) {
      adjacency[edge.from]?.add(edge);
      adjacency[edge.to]?.add(NavEdge(
        from: edge.to,
        to: edge.from,
        weight: edge.weight,
      ));
    }

    final distances = <String, double>{
      for (final node in nodes) node.id: double.infinity,
    };
    final previous = <String, String?>{
      for (final node in nodes) node.id: null,
    };
    distances[startId] = 0;

    // Min-heap priority queue: (distance, nodeId)
    final queue = SplayTreeSet<(double, String)>(
      (a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2),
    );
    queue.add((0, startId));

    while (queue.isNotEmpty) {
      final current = queue.first;
      queue.remove(current);
      final currentId = current.$2;
      final currentDist = current.$1;

      if (currentId == endId) break;
      if (currentDist > (distances[currentId] ?? double.infinity)) continue;

      for (final edge in adjacency[currentId] ?? []) {
        final newDist = currentDist + edge.weight;
        if (newDist < (distances[edge.to] ?? double.infinity)) {
          queue.remove((distances[edge.to]!, edge.to));
          distances[edge.to] = newDist;
          previous[edge.to] = currentId;
          queue.add((newDist, edge.to));
        }
      }
    }

    // Reconstruct path
    if (distances[endId] == double.infinity) return [];

    final path = <String>[];
    String? current = endId;
    while (current != null) {
      path.insert(0, current);
      current = previous[current];
    }
    return path;
  }

  /// Converts a list of node IDs back to ordered [lng, lat] coordinate pairs.
  static List<List<double>> pathToCoordinates(
    List<String> pathIds,
    List<NavNode> nodes,
  ) {
    final nodeMap = {for (final n in nodes) n.id: n};
    return pathIds
        .map((id) => nodeMap[id])
        .where((n) => n != null)
        .map((n) => [n!.lng, n.lat])
        .toList();
  }

  /// Euclidean distance in metres between two lat/lng pairs (approximation
  /// suitable for small indoor distances).
  static double distance(double lat1, double lng1, double lat2, double lng2) {
    const d = 111320.0; // metres per degree latitude (approx)
    final dy = (lat2 - lat1) * d;
    final dx = (lng2 - lng1) * d * cos(lat1 * pi / 180);
    return sqrt(dx * dx + dy * dy);
  }
}
