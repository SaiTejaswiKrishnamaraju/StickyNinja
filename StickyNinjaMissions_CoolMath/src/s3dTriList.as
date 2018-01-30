package  
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	if (PROJECT::useStage3D)
	{

	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	}
	/**
	 * ...
	 * @author 
	 */
	public class s3dTriList 
	{
		public var indices:Vector.<uint>;
		public var vertices:Vector.<Number>;
		public var vertices_extra:Vector.<Number>;
		public var hasBeenUploaded:Boolean;
		
		
		
		public var currentV:int;
		public var currentI:int;
		public var vBA:ByteArray;
		public var iBA:ByteArray;
		
		
		PROJECT::useStage3D
		{
	
		public var vertexBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		}
		
		public function s3dTriList() 
		{
			hasBeenUploaded = false;
			vertexBuffer = null;
			indexBuffer = null;
		}
		
		public function CreateAndUploadByteArrays()
		{
			var numVerticesToUpload:int = (currentV) / s3d.vert_size;			
			vertexBuffer = s3d.context3D.createVertexBuffer(currentV/s3d.vert_size, s3d.vert_size);			
			vertexBuffer.uploadFromByteArray(vBA, 0, 0, numVerticesToUpload);

			s3d.context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // register "0" now contains x,y,z
			s3d.context3D.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // register 1 now contains u,v
			s3d.context3D.setVertexBufferAt(2, vertexBuffer, 4, Context3DVertexBufferFormat.BYTES_4);
			
			var numIndicesToUpload:int = (currentI);
			indexBuffer = s3d.context3D.createIndexBuffer(currentI);
			indexBuffer.uploadFromByteArray(iBA, 0, 0, numIndicesToUpload);
			
			hasBeenUploaded = true;
			
		}
		public function TestCreateStage3DBuffers()
		{
			if (hasBeenUploaded == false)
			{
				CreateAndUploadByteArrays();
			}
		}
		public function Init(numTriangles:int, vertSize:int,vertSize1:int)
		{
			if (numTriangles == 0)
			{
				indices = new Vector.<uint>();
				vertices = new Vector.<Number>();
				vertices_extra = new Vector.<Number>();				
			}
			else
			{
				indices = new Vector.<uint>(numTriangles * 3);
				vertices = new Vector.<Number>(numTriangles * 3*vertSize);
				vertices_extra = new Vector.<Number>(numTriangles * 3 * vertSize1);
			}
		}
		
		
		public function Append(pts:Array,uvs:Array)
		{
			var numTris:int = pts.length / 3;

			var currentV:int = vertices.length / 3;
			var currentVE:int = vertices_extra.length / 5;
			var currentI:int = indices.length;
			
			var t:Array = pts;
			var uvs:Array = uvs;
			
			for (var i:int = 0; i < numTris; i++)
			{	
				var i3:int = i * 3;
			
				var x0:Number = t[i3 + 0].x;
				var x1:Number = t[i3 + 1].x;
				var x2:Number = t[i3 + 2].x;
				var y0:Number = t[i3 + 0].y;
				var y1:Number = t[i3 + 1].y;
				var y2:Number = t[i3 + 2].y;
				
				var uv0:Point = uvs[i3 + 0];
				var uv1:Point = uvs[i3 + 1];
				var uv2:Point = uvs[i3 + 2];
				
				
				var z:Number = 0.9;
					
				var uvscale:Number = 1;
				
				vertices[currentV++] = x0;
				vertices[currentV++] = y0;
				vertices[currentV++] = z;
				vertices_extra[currentVE++] = uv0.x*uvscale;
				vertices_extra[currentVE++] = uv0.y*uvscale;
				vertices_extra[currentVE++] = 1;
				vertices_extra[currentVE++] = 1;
				vertices_extra[currentVE++] = 1;
				
				vertices[currentV++] = x1;
				vertices[currentV++] = y1;
				vertices[currentV++] = z;
				vertices_extra[currentVE++] = uv1.x*uvscale;
				vertices_extra[currentVE++] = uv1.y*uvscale;
				vertices_extra[currentVE++] = 1;
				vertices_extra[currentVE++] = 1;
				vertices_extra[currentVE++] = 1;

				vertices[currentV++] = x2;
				vertices[currentV++] = y2;
				vertices[currentV++] = z;
				vertices_extra[currentVE++] = uv2.x*uvscale;
				vertices_extra[currentVE++] = uv2.y*uvscale;
				vertices_extra[currentVE++] = 1;
				vertices_extra[currentVE++] = 1;
				vertices_extra[currentVE++] = 1;

				
				indices[currentI] = currentI;
				currentI++;
				indices[currentI] = currentI;
				currentI++;
				indices[currentI] = currentI;
				currentI++;
				
				
			}
			
		}
		
		
	}

}