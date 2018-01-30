package  
{
	
    import com.adobe.utils.*;
    import flash.display.*;
    import flash.display3D.*;
    import flash.display3D.textures.Texture;
	import flash.display3D.VertexBuffer3D;
    import flash.events.*;
	import flash.geom.ColorTransform;
    import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import LicPackage.LicDef;
	/**
	 * ...
	 * @author ...
	 */
	public class s3dPostProcess 
	{
		
		if (PROJECT::useStage3D)
		{
		
		public static var EFFECT_COLORMULT:int = 0;
		
		public function s3dPostProcess() 
		{
			
		}
		
    
        private static var mContext3d:Context3D;
        private static var mVertBuffer:VertexBuffer3D;
        private static var mIndexBuffer:IndexBuffer3D; 
        private static var mProgram:Program3D;
        private static var mTexture:Texture;
        private static var mTextureData:BitmapData;
        private static var mMatrix:Matrix3D = new Matrix3D();
        private static var mPixelSize:Number = 5.0;
        
        
        public static function InitOnce()
        {
            
            mContext3d = s3d.context3D;
          
			
			var vertices:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();
			
			var numw:int = 1;
			var numh:int = 1;
			var minx:Number = -1;
			var maxx:Number = 1;
			var miny:Number = -1;
			var maxy:Number = 1;
			
			var i:int = 0;
			for (var xtile:int = 0; xtile < numw; xtile++)
			{
				for (var ytile:int = 0; ytile < numh; ytile++)
				{
					var x0:Number = Utils.ScaleTo(minx, maxx, 0, numw, xtile);
					var x1:Number = Utils.ScaleTo(minx, maxx, 0, numw, xtile+1);
					var y0:Number = Utils.ScaleTo(minx, maxx, 0, numh, ytile);
					var y1:Number = Utils.ScaleTo(minx, maxx, 0, numh, ytile+1);
					
					var u0:Number = Utils.ScaleTo(0, 1, 0, numw, xtile);
					var u1:Number = Utils.ScaleTo(0, 1, 0, numw, xtile+1);
					var v0:Number = Utils.ScaleTo(1, 0, 0, numh, ytile);
					var v1:Number = Utils.ScaleTo(1, 0, 0, numh, ytile+1);
					
					vertices.push(x0, y0, 0, u0, v0);
					vertices.push(x1, y0, 0, u1, v0);
					vertices.push(x0, y1, 0, u0, v1);
					vertices.push(x1, y1, 0, u1, v1);
					
					indices.push(i + 0, i + 1, i + 2);
					indices.push(i + 1, i + 3, i + 2);
					i += 4;
				}
				
			}
			
				 
            mVertBuffer = mContext3d.createVertexBuffer(vertices.length/5, 5);
            mVertBuffer.uploadFromVector(vertices, 0,vertices.length/5);
            
            mIndexBuffer = mContext3d.createIndexBuffer(indices.length);            
            mIndexBuffer.uploadFromVector (indices, 0, indices.length);
            
			
			
			var assembler:AGALMiniAssembler = new AGALMiniAssembler();
			
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			var fragmentShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();

//-------------------------------------------------------------

			vertexShader = vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
                "m44 op, va0, vc0 \n" +
				"mov v0, va1\n"  	// v0 is texture position

			);						
			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,linear,nomip>\n" + //store texture in ft0
				"mul ft0,ft0,fc0 \n"+
				 "mov oc,ft0                                      "
			);
			s3d.AddShader(new s3dShader("pp_color_texture", vertexShader, fragmentShader));
			
//-------------------------------------------------------------

			vertexShader = vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
                "m44 op, va0, vc0"
			);						
			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				 "mov oc,fc0                                      "
			);
			s3d.AddShader(new s3dShader("pp_color", vertexShader, fragmentShader));

//-------------------------------------------------------------
            
        }
		
		static function SetShader(name:String)
		{
			var shader:s3dShader = s3d.shaderDictionary[name];
			mContext3d.setProgram(shader.program);
		}
		
		
		static var fragmentShader:ByteArray;
		static var vertexShader:ByteArray;
        
		
		public static function ApplyEffect_ColorMult(col:Vector3D)
		{
			
			s3d.SetCurrentShader("pp_color");
			
			s3d.TestDumpCurrentList(null);
			s3d.currentState.tx= null;
			
			s3d.SetCurrentTexture();
			
			mContext3d.setTextureAt(0, null);
			mContext3d.setTextureAt(1, null);
			
            mContext3d.setVertexBufferAt(0, mVertBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            
            // va1 holds uv
            mContext3d.setVertexBufferAt(1, null, 0, null);
			mContext3d.setVertexBufferAt(2, null, 0, null);
			
			
            mContext3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mMatrix, true);
			
			var v:Vector.<Number> = new Vector.<Number>();
			v.push(col.x, col.y, col.z, col.w);
			mContext3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0, v,1);
			
            mContext3d.drawTriangles(mIndexBuffer);
			
			// back to original state
			s3d.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, s3d.orthoCameraMatrix, true);
			s3d.positionVector[0] = 0;
			s3d.positionVector[1] = 0;
			s3d.positionVector[2] = 1;
			s3d.positionVector[3] = 1;
			s3d.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4,s3d.positionVector);			
			s3d.UploadIdentityRotScaleMatrix();

			
		}

		public static function ApplyEffect_Texture_ColorMult(tex:s3dTex,col:Vector3D)
		{
			
			s3d.SetCurrentShader("pp_color_texture");
			
			s3d.TestDumpCurrentList(tex);
			s3d.currentState.tx= tex;
			
			s3d.SetCurrentTexture();
			
			mContext3d.setTextureAt(0, tex.texture);
			mContext3d.setTextureAt(1, null);
			
            mContext3d.setVertexBufferAt(0, mVertBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            // va1 holds uv
            mContext3d.setVertexBufferAt(1, mVertBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
            mContext3d.setVertexBufferAt(2, null, 0, null);
			
			
            mContext3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mMatrix, true);
			
			var v:Vector.<Number> = new Vector.<Number>();
			v.push(col.x, col.y, col.z, col.w);
			mContext3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0, v,1);
			
            mContext3d.drawTriangles(mIndexBuffer);
			

			// back to original state
			s3d.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, s3d.orthoCameraMatrix, true);
			s3d.positionVector[0] = 0;
			s3d.positionVector[1] = 0;
			s3d.positionVector[2] = 1;
			s3d.positionVector[3] = 1;
			s3d.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4,s3d.positionVector);			
			s3d.UploadIdentityRotScaleMatrix();
		}
		
		
        public static function Render(_fromTexture:Texture)
        {
            if ( !mContext3d ) 
                return;
            
				
			var tex:s3dTex = GraphicObjects.GetDisplayObjByName("DisplacementMap").GetTexture(0);
			s3d.TestUploadTexture(tex);	
			
			mContext3d.setRenderToBackBuffer();
			mContext3d.clear(0, 0, 0);
			
            // va0 holds xyz
            mContext3d.setVertexBufferAt(0, mVertBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            
            // va1 holds uv
            mContext3d.setVertexBufferAt(1, mVertBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			mContext3d.setVertexBufferAt(2, null, 0, null);
			
			mContext3d.setTextureAt(0, _fromTexture);
			mContext3d.setTextureAt(1, tex.texture);
	
			mContext3d.setProgram(mProgram);
				
            // set vertex data from blank Matrix3D
            mContext3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mMatrix, true);
            

			var scale:Number = 0.2 + (Math.sin(Game.levelTimer * 0.02) * 0.1);
			var v:Vector.<Number> = new Vector.<Number>();
			v.push(0.0,0.0,scale,0);
			mContext3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, v,1);
			
			
            mContext3d.drawTriangles(mIndexBuffer);
			
			mContext3d.setTextureAt(1, null);
			
        }
		}
		
	}

}