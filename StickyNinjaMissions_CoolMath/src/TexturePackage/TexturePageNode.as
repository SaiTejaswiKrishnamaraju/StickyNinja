package TexturePackage
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class TexturePageNode 
	{
		var child:Vector.<TexturePageNode>;
		var theDof:DisplayObjFrame;
		var rect:Rectangle;
		public function TexturePageNode() 
		{
			child = new Vector.<TexturePageNode>();
			child.push(null, null);			
			theDof = null;
			rect = new Rectangle(0, 0, 1, 1);
		}
		
		function DofFitsIntoRect(dof:DisplayObjFrame):Boolean
		{
			if (
				(dof.sourceRect.width <= rect.width) &&
				(dof.sourceRect.height <= rect.height) )
				{
					return true;
				}
			return false;
		}
		function DofFitsIntoRectPerfectly(dof:DisplayObjFrame):Boolean
		{
			if (
				(dof.sourceRect.width == rect.width) &&
				(dof.sourceRect.height == rect.height) )
				{
					return true;
				}
			return false;
		}
		
		public function Insert(dof:DisplayObjFrame):TexturePageNode
		{
			if(child[0] != null && child[1] != null)	// isn't leaf
			{
				// try inserting in to first child
				var newNode:TexturePageNode = child[0].Insert(dof);
				if (newNode != null) return newNode;
				
				// no room, insert in to second
				return child[1].Insert(dof);
			}
			else
			{
				// if already a frame here return null
				if (theDof != null) return null;
				
				// if we're too small, return null
				if (DofFitsIntoRect(dof) == false)
				{
					return null;
				}
				
				// if fit fits perfectly, accept it
				if (DofFitsIntoRectPerfectly(dof))
				{
					dof.sourceRect.x = rect.x;
					dof.sourceRect.y = rect.y;
					dof.sourceRect.width = rect.width;
					dof.sourceRect.height = rect.height;
					//dof.sourceRect.copyFrom(rect);
					theDof = dof;
					
					TexturePages.currentPage.items.push(dof);
					dof.assignedToTexturePage = true;

					return this;
				}
				
				//  split this node up in to 2 choldren
				child[0] = new TexturePageNode();
				child[1] = new TexturePageNode();
				
				// decide which way to split:
				var bw:int = dof.sourceRect.width;
				var bh:int = dof.sourceRect.height;
				var dw:Number = rect.width - bw;
				var dh:Number = rect.height - bh;
				
				if (dw > dh)
				{
					child[0].rect = new Rectangle(rect.left, rect.top, bw, rect.height);
					child[1].rect = new Rectangle(rect.left+bw, rect.top, rect.width-bw, rect.height);
				}
				else
				{
					child[0].rect = new Rectangle(rect.left, rect.top, rect.width, bh);
					child[1].rect = new Rectangle(rect.left, rect.top+bh, rect.width, rect.height-bh);					
				}
				
				return child[0].Insert(dof);
			}
		}
		
	}

}