package LayoutPackage
{
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class Layout
	{
		
		
		static var nodes:Vector.<Layout_Node>;
		static var edges:Vector.<Layout_Edge>;
		
		
		[Embed(source = "../../bin/layout.xgml", mimeType = "application/octet-stream")] 
        private static var class_layout:Class; 
		public static var layout_xml:XML;
		
		public function Layout() 
		{
			
		}
		
		public static function InitOnce()
		{
			nodes = new Vector.<Layout_Node>();
			edges = new Vector.<Layout_Edge>();
			
			Utils.print("LOADING LAYOUT XML");
			
			var xmlLayoutObj:Object = new class_layout(); 
			layout_xml = new XML(xmlLayoutObj) as XML; 
			
			var x:XML = layout_xml;

			var count:int = x.section.section.length();
			var i:int;
			for (i = 0; i < count; i++)
			{
				var nx:XML = x.section.section[i];
				
				if (nx.@name == "node")
				{				
					var node:Layout_Node = new Layout_Node();					
					node.id = String(nx.attribute[0]);
					node.label = String(nx.attribute[1]);
					node.layouttype = String(nx.section[0].attribute[4]);
					
					if (node.layouttype == "roundrectangle")	// level
					{
						node.type = "level";						
					}
					if (node.layouttype == "octagon")	// requirement
					{
						node.type = "requirement";
					}
					if (node.layouttype == "ellipse")	// result
					{
						node.type = "result";
					}
					if (node.layouttype == "parallelogram")	// award
					{
						node.type = "award";
					}
					if (node.layouttype == "hexagon")	// char
					{
						node.type = "bike";
					}
					if (node.layouttype == "trapezoid2")	// bike
					{
						node.type = "bike";
					}
					if (node.layouttype == "trapezoid")	//
					{
						node.type = "minigame";
					}
					if (node.layouttype == "triangle")	//
					{
						node.type = "extra_requirement";
					}
					
					nodes.push(node);					
				}
				if (nx.@name == "edge")
				{
					var edge:Layout_Edge = new Layout_Edge();					
					edge.link0 = String(nx.attribute[0]);
					edge.link1 = String(nx.attribute[1]);					
					//Utils.trace("edge: " + edge.link0+ " " + edge.link1);
					edges.push(edge);					
				}
				
				SetupAwardNodes();
				ValidateNodes();
				
			}			
		}

		static function ValidateNodes()
		{
			for each(var node:Layout_Node in nodes)
			{			
				node.Validate();
//				Utils.trace("node: " + node.id + " " + node.label + " " + "["+node.type+"]");

			}
		}
		static function SetupAwardNodes()
		{
			for each(var node:Layout_Node in nodes)
			{
				if (node.type == "award")
				{
					var childNode:Layout_Node = GetNodeChildNode(node);
					if (childNode == null)
					{
						node.label = "";
					}
					else
					{
						node.label = childNode.label;
					}
				}
			}			
		}
		static function GetLevelByIndex(_index:int):Layout_Node
		{
			var i:int = 0;
			for each(var node:Layout_Node in nodes)
			{
				if (node.type == "level")
				{
					if (i == _index) return node;
					i++;
				}
			}
			return null;
		}
		
		public static function GetLevelNodeList():Array
		{
			var a:Array = new Array();
			for each(var node:Layout_Node in nodes)
			{
				if (node.type == "level")
				{
					if (node.label != "" && node.label != null)
					{
						a.push(node);
					}
				}
			}
			return a;
		}

		public static function GetMinigameNodeList():Array
		{
			var a:Array = new Array();
			for each(var node:Layout_Node in nodes)
			{
				if (node.type == "minigame")
				{
					if (node.label != "" && node.label != null)
					{
						a.push(node);
					}
				}
			}
			return a;
		}

		
		static function GetLevelByName(name:String):Layout_Node
		{
			for each(var node:Layout_Node in nodes)
			{
				if (node.type == "level")
				{
					if (node.label == name) return node;
				}
			}
			return null;
		}

		static function GetNodeByID(id:String):Layout_Node
		{
			for each(var node:Layout_Node in nodes)
			{
				if (node.id == id) return node;
			}
			return null;
		}
		
		static function GetMinigameNode(name:String):Layout_Node
		{
			for each(var node:Layout_Node in nodes)
			{
				if (node.type == "minigame")
				{
					if (node.label == name) return node;
				}
			}
			return null;
			
		}
		
		
		
		public static function GetLevelRequirement(levelName:String):Layout_Node
		{
			var levelNode:Layout_Node = GetLevelByName(levelName);
			if (levelNode == null) return null;
			var parentNode:Layout_Node = GetNodeParentNode(levelNode);
			if (parentNode != null)
			{
				if (parentNode.type != "requirement" && parentNode.type != "bike") return null;
			}
			else
			{
				return null;
			}
			return parentNode;			
		}
		
		static function GetNodeParentNode(node:Layout_Node)
		{
			for each(var edge:Layout_Edge in edges)
			{
				if (edge.link1 == node.id)
				{
					var parentNode:Layout_Node = GetNodeByID(edge.link0);
					return parentNode;
				}
			}
			return null;
		}

		public static function GetNodeChildNodeList(node:Layout_Node):Array
		{
			var a:Array = new Array();
			for each(var edge:Layout_Edge in edges)
			{
				if (edge.link0 == node.id)
				{
					var childNode:Layout_Node = GetNodeByID(edge.link1);
					a.push(childNode);
				}
			}
			return a;
		}

		public static function GetNodeChildNode(node:Layout_Node):Layout_Node
		{
			var a:Array = new Array();
			for each(var edge:Layout_Edge in edges)
			{
				if (edge.link0 == node.id)
				{
					var childNode:Layout_Node = GetNodeByID(edge.link1);
					return childNode;
				}
			}
			return null;
		}
		
		
	}

}