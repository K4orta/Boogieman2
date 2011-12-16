package org.lemonparty{
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	/**
	 * Class which implements the A* pathfinding algorithm
	 * @author Vexhel
	 * Thanks to Rolpege and Valenti for fixes
	 */
	public class FlxPathfinding {
		private var _map:FlxTilemap;
		private var _nodes:Vector.<FlxPathfindingNode>;
		private var _open:Vector.<FlxPathfindingNode>;
		private var _closed:Vector.<FlxPathfindingNode>;
		
		private var _touched:Vector.<FlxPathfindingNode>;
		
		//we use int (instead of Number) to get better performance
		private const COST_ORTHOGONAL:int = 10;
		private const COST_DIAGONAL:int = 14;
		private const COST_DIRT:int = 20;
		
		public var allowDiagonal:Boolean = false;
		public var calculeNearestPoint:Boolean = false;
		public function FlxPathfinding(tilemap:FlxTilemap) {
			setMap(tilemap);
			_touched = new Vector.<FlxPathfindingNode>();
		}
		
		public var collideIndex:uint = 10;
		
		public function setMap(tilemap:FlxTilemap):void {
			_map = tilemap;
			//initialize the node structure
			_nodes = new Vector.<FlxPathfindingNode>();
			trace(tilemap.totalTiles);
			for (var i:int = 0; i < tilemap.totalTiles; i++) {
				_nodes.push(new FlxPathfindingNode(i % _map.widthInTiles, int(i / _map.widthInTiles), (_map.getTileByIndex(i) < collideIndex)));
				figureMoves(_nodes[_nodes.length - 1]);
			}
		}
		
		public function clear(X:int, Y:int):Boolean {
			var gt:uint = _map.getTile(X, Y);
			return gt < collideIndex || gt == 18;
		}
		
		public function figureMoves(Node:FlxPathfindingNode):void {
			var x:int=Node.x;
			var y:int = Node.y;
			
			if (clear(x, y - 1)&&(!clear(x-1,y))||!clear(x+1,y)) {
				Node.cmu = true;
			}
			
			if (clear(x, y + 1)) {
				Node.cmd = true;
			}
			
			if (clear(x-1, y)&&(!clear(x,y+1)||!clear(x-1,y+1))) {
				Node.cml = true;
			}
			
			if (clear(x+1, y)&&(!clear(x,y+1)||!clear(x+1,y+1))) {
				Node.cmr = true;
			}
			//check for ladder
			if (_map.getTile(x,y)==18) {
				Node.cmu = true;
			}
			
			if (!clear(x, y - 1)) {
				Node.cmu = false;
			}
		}
		
		//given a start and an end points, returns an array of points representing the shortest path (if any) between them
		public function findPath(startPoint:FlxPoint, endPoint:FlxPoint):Array{
			_open = new Vector.<FlxPathfindingNode>();
			_closed = new Vector.<FlxPathfindingNode>();
			
			for (var i:int = 0; i < _touched.length; i++) {
				_touched[i].parent = null;
			}
			_touched = new Vector.<FlxPathfindingNode>();
			/*for (var i:int = 0; i < _nodes.length; i++) {
				_nodes[i].parent = null;
			}*/
			
			var start:FlxPathfindingNode = getNodeAt(startPoint.x, startPoint.y);
			var end:FlxPathfindingNode = getNodeAt(endPoint.x, endPoint.y);
			var its:int = 0;
			_open.push(start);
			start.g = 0;
			start.h = calcDistance(start, end);
			start.f = start.h;	
			
			while (_open.length > 0) {
				//trace(Math.random());
				++its;
				var f:int = int.MAX_VALUE;
				var currentNode:FlxPathfindingNode;
				//choose the node with the lesser cost f
				for (var j:int = 0; j < _open.length; j++) { 
					if (_open[j].f < f) {
						currentNode = _open[j];
						f = currentNode.f;
					}
				}
				//we arrived at the end node, so we finish
				if (currentNode == end) {
					//trace(its);
					return rebuildPath(currentNode);
				}
				//we visited this node, so we can remove it from open and add it to closed
				_open.splice(_open.indexOf(currentNode), 1);
				_closed.push(currentNode);
				//do stuff with the neighbors of the current node
				for each (var n:FlxPathfindingNode in getNeighbors(currentNode)) {
					//skip nodes that has already been visited
					if (_closed.indexOf(n) > -1) {
						continue;
					}
					var g:int = currentNode.g + n.cost;
					if (_open.indexOf(n) == -1) {
						_open.push(n);
						n.parent = currentNode;
						n.g = g;					//path travelled so far
						n.h = calcDistance(n, end); //estimated path to goal
						n.f = n.g + n.h;
						_touched.push(n);
					} else if (g < n.g) {
						n.parent = currentNode;
						n.g = g;
						n.h = calcDistance(n, end);
						n.f = n.g + n.h;
						_touched.push(n);
					}
				}
			}
			//no path can be found
			if(calculeNearestPoint)
			{
				var min:int = int.MAX_VALUE;
				var nearestNode:FlxPathfindingNode;
				//find the reachable node that is nearer to the goal
				for each(var c:FlxPathfindingNode in _closed) {
					var dist:Number = calcDistance(c, end);
					if (dist < min) {
						min = dist;
						nearestNode = c;
					}
				}
				return rebuildPath(nearestNode); //returns the path to the node nearest to the goal
			}
			else
			{
				return null;
			}
		}
		
		
		public function getNodeAt(x:int, y:int):FlxPathfindingNode {
			return _nodes[x + y * _map.widthInTiles];
		}
		
		//returns an array from a linked list of nodes
		private function rebuildPath(end:FlxPathfindingNode):Array {
			var path:Array= new Array();
			if (end == null) {
				return path;
			}
			var n:FlxPathfindingNode = end;
			while (n.parent != null) {
				path.push(new FlxPoint(n.x*16+8, n.y*16+8));
				n = n.parent;
			}
			//trace(_touched.length);
			return path.reverse();
		}
		
		private function getNeighbors(node:FlxPathfindingNode):Vector.<FlxPathfindingNode> {
			var x:int = node.x;
			var y:int = node.y;
			var currentNode:FlxPathfindingNode;
			var neighbors:Vector.<FlxPathfindingNode> = new Vector.<FlxPathfindingNode>();
			
			if (x>0) {
				if (node.cml) {
					currentNode = getNodeAt(x - 1, y);
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			}
			
			if (x < _map.widthInTiles - 1) {
				if (node.cmr) {
					currentNode = getNodeAt(x + 1, y);
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			}
			
			if (y > 0) {
				if (node.cmu) {
					currentNode = getNodeAt(x, y - 1);
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			}
			
			if (y < _map.heightInTiles - 1) {
				if(node.cmd){
					currentNode = getNodeAt(x, y + 1);
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			}
			
			/*if (x > 0) {
				currentNode = getNodeAt(x - 1, y);
				if (currentNode.walkable) {
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			}
			if (x < _map.widthInTiles - 1) {
				currentNode = getNodeAt(x + 1, y);
				if (currentNode.walkable) {
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			} 
			if (y > 0) {
				currentNode = getNodeAt(x, y - 1);
				if (currentNode.walkable) {
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			}
			if (y < _map.heightInTiles - 1) {
				currentNode = getNodeAt(x, y + 1);
				if (currentNode.walkable) {
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			}*/
			
			/* We're not using any diagonal pathing
			if (allowDiagonal){
				if (x > 0 && y > 0) {
					currentNode = getNodeAt(x - 1, y - 1);
					if (currentNode.walkable && getNodeAt(x - 1, y).walkable && getNodeAt(x, y - 1).walkable) {
						currentNode.cost = COST_DIAGONAL;
						neighbors.push(currentNode);
					}
				}
				if (x < _map.widthInTiles - 1 && y > 0) {
					currentNode = getNodeAt(x + 1, y - 1);
					if (currentNode.walkable && getNodeAt(x + 1, y).walkable && getNodeAt(x, y - 1).walkable) {
						currentNode.cost = COST_DIAGONAL;
						neighbors.push(currentNode);
					}
				}
				if (x > 0 && y < _map.heightInTiles - 1) {
					currentNode = getNodeAt(x - 1, y + 1);
					if (currentNode.walkable && getNodeAt(x - 1, y).walkable && getNodeAt(x, y + 1).walkable) {
						currentNode.cost = COST_DIAGONAL;
						neighbors.push(currentNode);
					}
				}
				if (x < _map.widthInTiles - 1 && y < _map.heightInTiles - 1) {
					currentNode = getNodeAt(x + 1, y + 1);
					if (currentNode.walkable && getNodeAt(x + 1, y).walkable && getNodeAt(x, y + 1).walkable) {
						currentNode.cost = COST_DIAGONAL;
						neighbors.push(currentNode);
					}
				}
			}*/
			return neighbors;
		}
		
		//cheap way to calculate an approximate distance between two nodes
		private function calcDistance(start:FlxPathfindingNode, end:FlxPathfindingNode):int {
			if (start.x > end.x) {
				if (start.y > end.y) {
					return (start.x - end.x) + (start.y - end.y);
				} else {
					return (start.x - end.x) + (end.y - start.y);
				}
			} else {
				if (start.y > end.y) {
					return (end.x - start.x) + (start.y - end.y);
				} else {
					return (end.x - start.x) + (end.y - start.y);
				}
			}
		}
		
		//not sure which one is faster, have to do some test
		/*private function calcDistance2(start:FlxPathfindingNode, end:FlxPathfindingNode):int {
			return Math.abs(n1.x-n2.x)+Math.abs(n1.y-n2.y);
		}*/
		
		

	}
}