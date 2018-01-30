package  
{
	
// "$(ToolsDir)\azoth\azoth.exe" "$(OutputDir)\$(OutputName)" "$(OutputDir)\$(OutputName)"

	if (PROJECT::useStage3D)
	{
		import AchievementPackage.Achievement;
		import EditorPackage.EdLine;
		import flash.desktop.NativeApplication;
		import flash.desktop.SystemIdleMode;
		import com.buraks.utils.fastmem;
		import flash.display3D.Context3DProfile;
		import flash.events.ErrorEvent;
		import flash.utils.Dictionary;
		import flash.system.ApplicationDomain;
		import flash.utils.Endian;
		import flash.geom.Vector3D;
		import flash.geom.ColorTransform;
		import flash.geom.Matrix3D;
		import com.adobe.utils.AGALMiniAssembler;
		import flash.utils.setTimeout;
		import TexturePackage.TexturePage;
		import TexturePackage.TexturePages;
		
		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.display.Stage;
		import flash.display.Stage3D;
		import flash.display.Stage3D;
		import flash.display3D.Context3D;
		import flash.display3D.Context3DBlendFactor;
		import flash.display3D.Context3DCompareMode;
		import flash.display3D.Context3DProgramType;
		import flash.display3D.Context3DRenderMode;
		import flash.display3D.Context3DTextureFormat;
		import flash.display3D.Context3DTriangleFace;
		import flash.display3D.Context3DVertexBufferFormat;
		import flash.display3D.IndexBuffer3D;
		import flash.display3D.Program3D;
		import flash.display3D.textures.Texture;
		import flash.display3D.textures.TextureBase;
		import flash.display3D.VertexBuffer3D;
		import flash.events.Event;
		import flash.events.Event;
		import flash.geom.Matrix;
		import flash.geom.Point;
		import flash.utils.ByteArray;
		import LicPackage.LicDef;
	}
		
		public class s3d 
		{
			// Test class for Stage3D stuff.
			
			public function s3d() 
			{
				
			}
			
			
			public static var usePostProcess:Boolean = false;
			public static var pauseRender:Boolean = false;
			public static var recordTextureUsage:Boolean = false;
			public static var enableErrorChecking:Boolean = false;
			
			static var perFrameTextureUsage:Array = new Array();
			
			public static var BLENDMODE_NONE:int = -1;
			public static var BLENDMODE_ALPHA:int = 0;
			public static var BLENDMODE_SOLID:int = 1;
			
			PROJECT::useStage3D
			{
			public static var sceneTexture:Texture;
			public static var useRingOfBuffers:Boolean = true;
			public static var useFastMem:Boolean = false;
			
			static var currentState:s3dState;
			
			static const vert_size:int = 5;
			
			public static var triangleLists:Array;

			static var uploadedTextureOnce:Boolean = false;
			static var vcol:Vector.<Number> = new Vector.<Number>(4);
			
			static var vertexBufferSize:int = vert_size * 16384;
			static var indexBufferSize:int = 16384;
			
			static var verticesBA:ByteArray;
			static var indicesBA:ByteArray;
			
			static var vertices:Vector.<Number> = new Vector.<Number>(vert_size * 16384);
			static var indices:Vector.<uint> = new Vector.<uint>(16384 * 6);
			static var current_vertex_index:int;
			static var current_index_index:int;
			
			static var transformedVerts:Vector.<Number> = new Vector.<Number>(8192);
			
			static var currentZ:Number;
			static var zAdder:Number;
			
			public static var stage3D:Stage3D;
			public static var context3D:Context3D;
			
			static var program3D:Program3D;
			static var vertexBuffer:VertexBuffer3D;
			static var indexBuffer:IndexBuffer3D;
			static var fragmentShader:ByteArray;
			static var vertexShader:ByteArray;

			
			
			static var fullVertexBuffer:VertexBuffer3D;
			static var fullIndexBuffer:IndexBuffer3D;
			
			
			public static function SetVisible(_vis:Boolean)
			{
				if (PROJECT::useStage3D == false) return;
				stage3D.visible = _vis;
			}
			
			static var _initCallbackFunction:Function;
			
			static var RotScaleMatrix:Matrix3D;
			static var orthoCameraMatrix:Matrix3D;
			
			static var isInitialised:Boolean = false;
			
			
			
			
			public static function InitOnce(_cb:Function)
			{				
				
				_initCallbackFunction = _cb;

				if (PROJECT::useStage3D == false)
				{
					_initCallbackFunction();
					return;
				}

				
				if (isInitialised)
				{
					_initCallbackFunction();
					return;
				}

				
				triangleLists = new Array();

				var p_far:Number = 1;
				var p_near:Number = 0;
				var m:Matrix3D = new Matrix3D(Vector.<Number> (
				   [2/Defs.displayarea_w, 0,  0,  0,
					0, 2/Defs.displayarea_h, 0, 0,
					0, 0, 1/(p_far - p_near), -p_near/(p_far-p_near),
					0, 0, 0, 1]));
			
				
				orthoCameraMatrix = new Matrix3D();
				   orthoCameraMatrix.appendTranslation(-Defs.displayarea_w/2, -Defs.displayarea_h/2, 0);
				   orthoCameraMatrix.appendScale(1, -1, 1);  
				   orthoCameraMatrix.append(m);
				
				RotScaleMatrix = new Matrix3D();
				RotScaleMatrix.identity();
				
				if (PROJECT::useStage3D)
				{
					NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
					//NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
					
				}
				
				
				var s:Stage  = LicDef.GetStage().stage;
				if (s == null)
				{
					_initCallbackFunction();
				}
				else
				{

					var delay:int = 200;
					var stage3D:Stage3D = s.stage3Ds[0]; 
					stage3D.addEventListener(flash.events.Event.CONTEXT3D_CREATE, onExtendedComplete);
					stage3D.addEventListener(ErrorEvent.ERROR, onExtendedComplete);

					try { //Try and request EXTENDED profile.
						 stage3D.requestContext3D("auto", Context3DProfile.BASELINE_EXTENDED); 
					} catch (e:Error) { onExtendedComplete(); }

					function onExtendedComplete(event:* = null):void 
					{
						 var success:Boolean = (event && !(event is ErrorEvent));
						 stage3D.removeEventListener(flash.events.Event.CONTEXT3D_CREATE, onExtendedComplete);
						 stage3D.removeEventListener(ErrorEvent.ERROR, onExtendedComplete);
						 if(stage3D.context3D){ stage3D.context3D.dispose(false); }
						 
						 setTimeout(function(){
							  var profile:String = success? Context3DProfile.BASELINE_EXTENDED : Context3DProfile.BASELINE;
							  PooStage3D(profile); //Call your normal startUp routine.
						 }, delay);
					}

				}
				
			}
			
			static function PooStage3D(profile:String)
			{
				selectedProfile = profile;
				var s:Stage  = LicDef.GetStage().stage;
				s.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, initStage3D);
				s.stage3Ds[0].requestContext3D( Context3DRenderMode.AUTO, profile);
				
			}
			static var selectedProfile:String = "";
			
			static var previousContext:Context3D = null;
			static function initStage3D(e:Event):void
			{
				//_initCallbackFunction();
				
				var s:Stage  = LicDef.GetStage().stage;
//				s.stage3Ds[0].removeEventListener( Event.CONTEXT3D_CREATE, initStage3D);
				
				stage3D = e.target as Stage3D;
				context3D = stage3D.context3D;	
				//Utils.trace(" Stage3d initialised ");
				

				if (previousContext == null)
				{
					
					trace("stage3d created");
				}
				else
				{
					trace("stage3d context lost");
					
					_initCallbackFunction = null;
					for each(var tp:TexturePage in TexturePages.pages)
					{
						tp.beenUploaded = false;
						tp.s3dTexture.texture = null;
					}
					for each(var tl:s3dTriList in triangleLists)
					{
						tl.hasBeenUploaded = false;
					}
				}

				previousContext = context3D;
				
				context3D.enableErrorChecking = enableErrorChecking;
				
				stage3D.x = ScreenSize.fullScreenScaleXOffset;
				stage3D.y = ScreenSize.fullScreenScaleYOffset;
				
				
				if (PROJECT::useStage3D)
				{
					context3D.configureBackBuffer(ScreenSize.visibleW,ScreenSize.visibleH, 0, false,true);
				}
				else
				{
					context3D.configureBackBuffer(Defs.displayarea_w,Defs.displayarea_h, 0, false);
				}
					
					InitPrograms();
					
					if (usePostProcess)
					{
						
						sceneTexture = context3D.createTexture(512, 256, Context3DTextureFormat.BGRA, true, 0);
//						nextPowerOfTwo(ScreenSize.visibleW),
//						nextPowerOfTwo(ScreenSize.visibleH),
//						Context3DTextureFormat.BGRA, true);
					}
					
//					context3D.setDepthTest(true, Context3DCompareMode.LESS);
					
					context3D.setCulling(Context3DTriangleFace.NONE);
					
					
					isInitialised = true;

					
					verticesBA = new ByteArray();
					indicesBA = new ByteArray();
					
					verticesBA.endian = Endian.LITTLE_ENDIAN;
 					indicesBA.endian = Endian.LITTLE_ENDIAN; 

					for (var i:int = 0; i < vertexBufferSize; i++)
					{
						verticesBA.writeDouble(0);
					}
					for (var i:int = 0; i < indexBufferSize; i++)
					{
						indicesBA.writeShort(0);
					}

					
					
//					fullVertexBuffer = context3D.createVertexBuffer(vertexBufferSize/vert_size,vert_size);
//					fullIndexBuffer = context3D.createIndexBuffer(indexBufferSize);

//					fullVertexBuffer.uploadFromByteArray(verticesBA, 0, 0, vertexBufferSize/vert_size);
//					fullIndexBuffer.uploadFromByteArray(indicesBA, 0, 0, indexBufferSize);

					CreateRingOfBuffers();
					
					InitState();
					
					texClampVector = new Vector.<Number>();
					texClampVector.push(0);
					texClampVector.push(0);
					texClampVector.push(0);
					texClampVector.push(0);

					texClampVector1 = new Vector.<Number>();
					texClampVector1.push(0);
					texClampVector1.push(0);
					texClampVector1.push(0);
					texClampVector1.push(0);
					
					positionVector = new Vector.<Number>();
					positionVector.push(0);
					positionVector.push(0);
					positionVector.push(0);
					positionVector.push(0);
					
					if (_initCallbackFunction != null)
					{
						_initCallbackFunction();
					}
					
				s3dPostProcess.InitOnce();
			}

			public static function nextPowerOfTwo(v:uint): uint
			{
				v--;
				v |= v >> 1;
				v |= v >> 2;
				v |= v >> 4;
				v |= v >> 8;
				v |= v >> 16;
				v++;
				return v;
			}			
			
			static function InitState()
			{
				currentState = new s3dState();
			}
			static function UpdateState()
			{
				
			context3D.setProgram(shaders[0].program);
				
			}
			static function ResetState()
			{
				currentState.Reset();
			}

			
			
			static var shaders:Array;
			static var shaderDictionary:Dictionary;
			static function InitShaders()
			{
				shaders = new Array();
				shaderDictionary = new Dictionary();
			}
			static function AddShader(shader:s3dShader)
			{
				shaders.push(shader);
				shaderDictionary[shader.name] = shader;
			}
			
		
		private static function InitPrograms() : void 
		{
			var assembler:AGALMiniAssembler = new AGALMiniAssembler();
			
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			var fragmentShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			
			
			InitShaders();
			
			
			
// Adding in an xy offset
// and color coming in in va2.z
// va0 is x,y pos
// va1 is uv
// va2 is color mult
			vertexShader = vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"mov vt2,va0\n" +		// get x,y pos (vt2)
				"add vt2.xy,vc4.xy,vt2.xy\n" +	// add in x,y offsets (vt2)
				"m44 vt2, vt2, vc8\n" +		// multiply but constant scale / rot matrix
				"m44 vt0, vt2, vc0\n" +		// multiply x,y by constant matrix, in to vt0
				"mov op, vt0\n" +			// and store vt0 in to output position (op)
				"mov v0, va1\n" + 	// v0 is texture position
				//"mov v1, va2\n" 	// v1 is color to multiply in
				
				"mov vt2,va2\n" +
				"add vt2,vt2,vt2\n" +
				"mov v1, vt2\n" 	// v1 is color to multiply in * 2 (ie 0-2)
			);						
			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,linear,nomip>\n" + //store texture in ft0
				"mul oc,ft0,v1"
			);
			AddShader(new s3dShader("colormul", vertexShader, fragmentShader));

			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,linear,nomip,dxt1>\n" + //store texture in ft0
				"mul oc,ft0,v1\n"
			);
			AddShader(new s3dShader("colormul_compressed_opaque", vertexShader, fragmentShader));

			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,linear,nomip,dxt5>\n" + //store texture in ft0
				"mul oc,ft0,v1"
			);
			AddShader(new s3dShader("colormul_compressed_transparent", vertexShader, fragmentShader));
			

//				"tex ft0, v0, fs0 <2d,wrap,linear,nomip,dxt5>\n" + //store texture in ft0
//				"mul ft0,ft0,v1\n" +
//				"mov oc, ft0" // move to output colour
			
// Adding in an xy offset
// and color coming in in va2.z
// va0 is x,y pos
// va1 is uv
// va2 is color mult
			vertexShader = vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
			
				"mov vt2,va0\n" +		// get x,y pos (vt2)
				"add vt2.xy,vc4.xy,vt2.xy\n" +	// add in x,y offsets (vt2)
				"m44 vt2, vt2, vc8\n" +		// multiply but constant scale / rot matrix
				"m44 vt0, vt2, vc0\n" +		// multiply x,y by constant matrix, in to vt0
				"mov op, vt0\n" +			// and store vt0 in to output position (op)
				"mov v0, va1\n" + 	// v0 is texture position
				"mov v1, va2\n" + 	// v1 is color to multiply in
				
				"mov vt2,va2\n" +
				"add vt2,vt2,vt2\n" +
				"mov v1, vt2\n" 	// v1 is color to multiply in * 2 (ie 0-2)
			);						
			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,linear,nomip>\n" + //store texture in ft0
				"mul ft0.w,ft0.w,v1.w\n" +
				"mov oc, ft0" // move to output colour
			);
			AddShader(new s3dShader("alphamul", vertexShader, fragmentShader));

			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,linear,nomip,dxt1>\n" + //store texture in ft0
				"mul ft0.w,ft0.w,v1.w\n" +
				"mov oc, ft0" // move to output colour
			);
			AddShader(new s3dShader("alphamul_compressed_opaque", vertexShader, fragmentShader));

			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,linear,nomip,dxt5>\n" + //store texture in ft0
				"mul ft0.w,ft0.w,v1.w\n" +
				"mov oc, ft0" // move to output colour
			);
			AddShader(new s3dShader("alphamul_compressed_transparent", vertexShader, fragmentShader));

				
// Adding in an xy offset
// and color coming in in va2.z
// va0 is x,y pos
// va1 is uv
// va2 is color mult
// COLOR IS IGNORED IN THE PIXEL SHADER
			vertexShader = vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"mov vt2,va0\n" +		// get x,y pos (vt2)
				"add vt2.xy,vc4.xy,vt2.xy\n" +	// add in x,y offsets (vt2)
				"m44 vt2, vt2, vc8\n" +		// multiply but constant scale / rot matrix
				"m44 vt0, vt2, vc0\n" +		// multiply x,y by constant matrix, in to vt0
				"mov op, vt0\n" +			// and store vt0 in to output position (op)
				"mov v0, va1\n" + 	// v0 is texture position
				"mov v1, va2\n" 	// v1 is color to multiply in
			);						
			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,linear,nomip>\n" + //store texture in ft0
				"mov oc, ft0" // move to output colour
			);
			AddShader(new s3dShader("normal", vertexShader, fragmentShader));
			
			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,linear,nomip,dxt1>\n" + //store texture in ft0
				"mov oc, ft0" // move to output colour
			);
			AddShader(new s3dShader("normal_compressed_opaque", vertexShader, fragmentShader));

			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,linear,nomip,dxt5>\n" + //store texture in ft0
				"mov oc, ft0" // move to output colour
			);
			AddShader(new s3dShader("normal_compressed_transparent", vertexShader, fragmentShader));

// Adding in an xy offset
// and color coming in in va2.z
// va0 is x,y pos
// va1 is uv
// va2 is color mult
// COLOR IS IGNORED IN THE PIXEL SHADER
			vertexShader = vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"mov vt2,va0\n" +		// get x,y pos (vt2)
				"add vt2.xy,vc4.xy,vt2.xy\n" +	// add in x,y offsets (vt2)
				"m44 vt2, vt2, vc8\n" +		// multiply but constant scale / rot matrix
				"m44 vt0, vt2, vc0\n" +		// multiply x,y by constant matrix, in to vt0
				"mov op, vt0\n" +			// and store vt0 in to output position (op)
				"mov v0, va1\n" + 	// v0 is texture position
				"mov v1, va2\n" 	// v1 is color to multiply in
			);						
			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,nearest,nomip>\n" + //store texture in ft0
				"mov oc, ft0" // move to output colour
			);
			AddShader(new s3dShader("normal_nearest", vertexShader, fragmentShader));
			
			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,nearest,nomip,dxt1>\n" + //store texture in ft0
				"mov oc, ft0" // move to output colour
			);
			AddShader(new s3dShader("normal_nearest_compressed_opaque", vertexShader, fragmentShader));

			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d,wrap,nearest,nomip,dxt5>\n" + //store texture in ft0
				"mov oc, ft0" // move to output colour
			);
			AddShader(new s3dShader("normal_nearest_compressed_transparent", vertexShader, fragmentShader));
			

// wrapping within a certain area, and adding in an xy offset	
// vc0 = matrix
// vc4 = x,y offset
// vc5 = texture clamp params  (x=startx, y=starty, z=width, w=height)
// va0 = pos
// va1 = uv
// va2 = color
			vertexShader = vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"mov vt6,vc5\n" +
				"mov vt5,va2\n" +		// color / alpha (unused)
				"mov vt2,va0\n" +
				"add vt2,vc4,vt2\n" +
				"m44 vt0, vt2, vc0\n" +				
				"mov op, vt0\n" +				
				"mov v1, vt6\n" +			// vertex register v1 is clamp params  (x=startx, y=starty, z=width, w=height)
				
				"mov v2,vt6\n" +
				
				"rcp v2.z, vt6.z\n" +			// store width reciprocals in v2
				"rcp v2.w, vt6.w\n" +			//
				"mov v0, va1\n" 			// vertex register v0 is uv
				
			);						
// v0 = uv pos
// v1 = texture clamp params (x=startx, y=starty, z=width, w=height)
// v2 = reciprocals (z=1/width, w=1/height)
			fragmentShader = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				
				// move uv input to temp0 (ft0)
				"mov ft0,v0\n" +
				
				
				// multiply up the uv to 0-1 range (using reciprocal of width / height)
				"mul ft0.xy,ft0.xy,v2.zw\n"+
				
				// keep the fraction
				"frc ft0.xy,ft0.xy\n"+
				
				//multiply down by the w/h again
				"mul ft0.xy,ft0.xy,v1.zw\n"+
				
				// add in texture origin uv offset
				"add ft0.xy,ft0.xy,v1.xy\n"+
				
			
				"tex ft0, ft0, fs0 <2d,wrap,nearest,nomip>\n" + //store texture in ft0
				"mov oc, ft0" // move to output colour
			);
			
			AddShader(new s3dShader("uvwrap", vertexShader, fragmentShader));
		}	

	
		static var positionVector:Vector.<Number>;
		static var texClampVector:Vector.<Number>;
		static var texClampVector1:Vector.<Number>;
		static var shaderUpdateCount:int;
		
	public static function StartRender()
	{
		if (context3D == null) return;
		
		if (pauseRender)
		{
			return;
		}
		
		if (usePostProcess)
		{
			context3D.setRenderToTexture(sceneTexture, false, 0, 0);
		}
		
		currentZ = 0.99;
		zAdder = -0.0001;
		
		shaderUpdateCount = 0;
		
		verticesBA.position = 0;
		indicesBA.position = 0;
		
		
		StartRecordTextureUsage();
		
		if (useFastMem)
		{
			fastmem.fastSelectMem(verticesBA);
		}
		
			totalCount = 0;
			textureUploadCount = 0;
			textureSkipUploadCount = 0;
		
				ResetState();
				
				currentState.programIndex = 0;
				currentState.xpos = 0;
				currentState.ypos = 0;
				currentState.tx = null;
				
				
				
				UpdateState();
				SetCurrentShader("null");

			SetCurrentBlendMode(BLENDMODE_NONE);

		
		
		
      
		
		context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, orthoCameraMatrix, true);
		positionVector[0] = 0;
		positionVector[1] = 0;
		positionVector[2] = 1;
		positionVector[3] = 1;
		context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4,positionVector);
		
		UploadRotScaleMatrix();	
		UploadIdentityRotScaleMatrix();
		
		
		context3D.clear(0, 0.0, 0.0);
//		context3D.clear(1,1,1,1);
		
		current_vertex_index = 0;
		current_index_index  = 0;
		
		batch_start_vertex_index = 0;
		batch_start_index_index = 0;

	}
	
	
	
	
	public static function UploadIdentityRotScaleMatrix()
	{
		RotScaleMatrix.identity();
		context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, RotScaleMatrix, true);
	}
	public static function UploadRotScaleMatrix()
	{
		context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, RotScaleMatrix, true);
	}
	
	public static function EndRender()
	{
		if (context3D == null) return;
		
		if (pauseRender == false)
		{

			
			DumpCurrentList();
			
			if (usePostProcess)
			{
				s3dPostProcess.Render(s3d.sceneTexture);
			}
			
			context3D.present();
			
			
			
			if (useFastMem)
			{
				fastmem.fastDeselectMem();
			}
		}
		
//		trace("shaderUpdateCount  " + shaderUpdateCount );
		
//		fullVertexBuffer.dispose();
//		fullIndexBuffer.dispose();
		
//		trace("num uploads " + textureUploadCount + "    textureSkipUploadCount: " + textureSkipUploadCount);
	}

		
	
		if (PROJECT::useStage3D)
		{
		// parameters in screen space
		public static function RenderLineA(_tx:s3dTex, x:Number, y:Number, x1:Number, y1:Number, u0:Number, v0:Number, u1:Number, v1:Number)
		{
			TestDumpCurrentList(_tx);
			currentState.tx = _tx;

			var currentV:int = current_vertex_index;
			var currentI:int = current_index_index;
		
			var p0:Point = new Point(x, y);
			var p1:Point =  new Point(x1, y1);
			
			var width2:Number = 2;
			
			var angle:Number = Math.atan2(p1.y - p0.y, p1.x - p0.x);
			angle -= (Math.PI / 2);
			var p2:Point = p0.clone();
			var p3:Point = p1.clone();
			var dx:Number = Math.cos(angle) * width2;
			var dy:Number = Math.sin(angle) * width2;
			p0.x -= dx;
			p0.y -= dy;
			p1.x -= dx;
			p1.y -= dy;
			
			p2.x += dx;
			p2.y += dy;
			p3.x += dx;
			p3.y += dy;
			
			verticesBA.writeFloat(p0.x);
			verticesBA.writeFloat(p0.y);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(p1.x);
			verticesBA.writeFloat(p1.y);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(p2.x);
			verticesBA.writeFloat(p2.y);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(p3.x);
			verticesBA.writeFloat(p3.y);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(0xffffffff);
			
			
			var offset:int = (batch_start_vertex_index + current_vertex_index) / vert_size;
			indicesBA.writeShort(offset+0);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+2);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+3);
			indicesBA.writeShort(offset+2);
			
			current_vertex_index += vert_size*4;
			current_index_index += 6;
			
			totalCount++;
			
		}
		
		public static function RenderLine(_tx:s3dTex, x:Number, y:Number, x1:Number, y1:Number, u0:Number, v0:Number, u1:Number, v1:Number)
		{
			TestDumpCurrentList(_tx);
			currentState.tx = _tx;

			var currentV:int = current_vertex_index;
			var currentI:int = current_index_index;
		
			verticesBA.writeFloat(x);
			verticesBA.writeFloat(y);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(x1);
			verticesBA.writeFloat(y1);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(x);
			verticesBA.writeFloat(y+2);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(x1);
			verticesBA.writeFloat(y1+2);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(0xffffffff);
			
			
			var offset:int = (batch_start_vertex_index + current_vertex_index) / vert_size;
			indicesBA.writeShort(offset+0);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+2);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+3);
			indicesBA.writeShort(offset+2);
			
			current_vertex_index += vert_size*4;
			current_index_index += 6;
			
			totalCount++;
			
		}
		
		}

		
		if (PROJECT::useStage3D)
		{
			
		public static function RenderRectangle_Color(matrix:Matrix3D, _tx:s3dTex, x:Number, y:Number, w:Number, h:Number, u0:Number = 0, v0:Number = 0, u1:Number = 1, v1:Number = 1,ct:ColorTransform = null)
		{
			TestDumpCurrentList(_tx);
			currentState.tx = _tx;
			
			var col:uint = 0x7f7f7f7f;
			if (ct != null)
			{
				var r:uint = (128 * ct.redMultiplier);
				var g:uint = (128 * ct.greenMultiplier);
				var b:uint = (128 * ct.blueMultiplier);
			
				var alpha:uint =  (128 * ct.alphaMultiplier);
				col = 0x00000000 | (alpha<<24) | (b << 16) | (g << 8) | r;
			}
			

			
			
			var currentV:int = current_vertex_index;
			var currentI:int = current_index_index;
		
			var mempos:int = verticesBA.position;
			
		
			verticesBA.writeFloat(x);
			verticesBA.writeFloat(y);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(col);
			
			verticesBA.writeFloat(x+w);
			verticesBA.writeFloat(y);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(col);
			
			verticesBA.writeFloat(x);
			verticesBA.writeFloat(y+h);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(col);
			
			verticesBA.writeFloat(x+w);
			verticesBA.writeFloat(y+h);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(col);
			
			var offset:int = (batch_start_vertex_index + current_vertex_index) / vert_size;
			indicesBA.writeShort(offset+0);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+2);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+3);
			indicesBA.writeShort(offset+2);
			
			
			current_vertex_index += vert_size*4;
			current_index_index += 6;

			totalCount++;
			
		}

		// x0,y0		x1,y1,
		// x2,y2		x3,y3
		public static function RenderQuad_Color(matrix:Matrix3D, _tx:s3dTex, x0:Number, y0:Number, x1:Number,y1:Number,x2:Number,y2:Number,x3:Number,y3:Number, u0:Number = 0, v0:Number = 0, u1:Number = 1, v1:Number = 1,ct:ColorTransform = null)
		{
			TestDumpCurrentList(_tx);
			currentState.tx = _tx;
			
			var col:uint = 0x7f7f7f7f;
			if (ct != null)
			{
				var r:uint = (128 * ct.redMultiplier);
				var g:uint = (128 * ct.greenMultiplier);
				var b:uint = (128 * ct.blueMultiplier);
			
				var alpha:uint =  (128 * ct.alphaMultiplier);
				col = 0x00000000 | (alpha<<24) | (b << 16) | (g << 8) | r;
			}
			

			
			
			var currentV:int = current_vertex_index;
			var currentI:int = current_index_index;
		
			var mempos:int = verticesBA.position;
			
		
			verticesBA.writeFloat(x0);
			verticesBA.writeFloat(y0);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(col);
			
			verticesBA.writeFloat(x1);
			verticesBA.writeFloat(y1);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(col);
			
			verticesBA.writeFloat(x2);
			verticesBA.writeFloat(y2);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(col);
			
			verticesBA.writeFloat(x3);
			verticesBA.writeFloat(y3);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(col);
			
			var offset:int = (batch_start_vertex_index + current_vertex_index) / vert_size;
			indicesBA.writeShort(offset+0);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+2);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+3);
			indicesBA.writeShort(offset+2);
			
			
			current_vertex_index += vert_size*4;
			current_index_index += 6;

			totalCount++;
			
		}
		
		
		public static function RenderHorizLine(_tx:s3dTex, x:Number, y:Number, x1:Number, y1:Number, u0:Number, v0:Number, u1:Number, v1:Number,_height:int)
		{
			TestDumpCurrentList(_tx);
			currentState.tx = _tx;
			
			var height:int = _height;

			var currentV:int = current_vertex_index;
			var currentI:int = current_index_index;
		
			verticesBA.writeFloat(x);
			verticesBA.writeFloat(y);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(x1);
			verticesBA.writeFloat(y);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(x);
			verticesBA.writeFloat(y+height);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(x1);
			verticesBA.writeFloat(y+height);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(0xffffffff);
			
			
			var offset:int = (batch_start_vertex_index + current_vertex_index) / vert_size;
			indicesBA.writeShort(offset+0);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+2);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+3);
			indicesBA.writeShort(offset+2);
			
			current_vertex_index += vert_size*4;
			current_index_index += 6;
			
			totalCount++;
			
		}

		public static function RenderTrapezium(_tx:s3dTex, 
				x0a:Number, x0b:Number, x1a:Number, x1b:Number,
				y0:Number, y1:Number, 
				u0a:Number, u0b:Number, u1a:Number, u1b:Number, 
				v0:Number, v1:Number )
		{
			TestDumpCurrentList(_tx);
			currentState.tx = _tx;
			
			var currentV:int = current_vertex_index;
			var currentI:int = current_index_index;
		
			verticesBA.writeFloat(x0a);
			verticesBA.writeFloat(y0);
			verticesBA.writeFloat(u0a);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(x1a);
			verticesBA.writeFloat(y0);
			verticesBA.writeFloat(u0b);
			verticesBA.writeFloat(v0);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(x0b);
			verticesBA.writeFloat(y1);
			verticesBA.writeFloat(u1a);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(0xffffffff);

			verticesBA.writeFloat(x1b);
			verticesBA.writeFloat(y1);
			verticesBA.writeFloat(u1b);
			verticesBA.writeFloat(v1);		
			verticesBA.writeInt(0xffffffff);
			
			
			var offset:int = (batch_start_vertex_index + current_vertex_index) / vert_size;
			indicesBA.writeShort(offset+0);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+2);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+3);
			indicesBA.writeShort(offset+2);
			
			current_vertex_index += vert_size*4;
			current_index_index += 6;
			
			totalCount++;
			
		}
		
		
		public static function RenderRectangle(matrix:Matrix3D, _tx:s3dTex, x:Number, y:Number, w:Number, h:Number, _dir:Number, u0:Number = 0, v0:Number = 0, u1:Number = 1, v1:Number = 1)
		{
			RenderRectangle_Color(matrix, _tx, x, y, w, h, u0, v0, u1, v1,null);
			return;
			
			
			var vsize:int = 4;
			
			TestDumpCurrentList(_tx);
			currentState.tx = _tx;
			
			var currentV:int = current_vertex_index;
			var currentI:int = current_index_index;
		
			var mempos:int = verticesBA.position;
			
			verticesBA.writeFloat(x);
			verticesBA.writeFloat(y);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v0);		
			
			verticesBA.writeFloat(x+w);
			verticesBA.writeFloat(y);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v0);		
			
			verticesBA.writeFloat(x);
			verticesBA.writeFloat(y+h);
			verticesBA.writeFloat(u0);
			verticesBA.writeFloat(v1);		
			
			verticesBA.writeFloat(x+w);
			verticesBA.writeFloat(y+h);
			verticesBA.writeFloat(u1);
			verticesBA.writeFloat(v1);		
			
			var offset:int = (batch_start_vertex_index + current_vertex_index) / vert_size;
			indicesBA.writeShort(offset+0);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+2);
			indicesBA.writeShort(offset+1);
			indicesBA.writeShort(offset+3);
			indicesBA.writeShort(offset+2);
			
			
			current_vertex_index += vsize*4;
			current_index_index += 6;

			totalCount++;
			
		}
		}

		

		if (PROJECT::useStage3D)
		{
			static function TestDumpCurrentList(_tx:s3dTex)
			{
				var shaderFullName:String = currentState.shaderName;
				if (_tx != null)
				{
					if (_tx.format == Context3DTextureFormat.COMPRESSED) 
					{
						shaderFullName += "_compressed_opaque";
					}
					if (_tx.format == Context3DTextureFormat.COMPRESSED_ALPHA) 
					{
						shaderFullName += "_compressed_transparent";
					}
				}
				if (currentState.shaderFullName != shaderFullName)
				{
					currentState.shaderFullName = shaderFullName;
					currentState.shader_updated = true;
				}
				
				var dumpit:Boolean = false;
				if (_tx != null)
				{
					if (currentState.tx != null)
					{
						if (_tx.id != currentState.tx.id)
						{
							dumpit = true;			
							
						}
					}
					else
					{
						textureSkipUploadCount++;
					}
				}	
	//			if (currentState.tx_updated)
	//			{
	//				dumpit = true;				
	//			}
				if (currentState.shader_updated)
				{
					dumpit = true;							
					currentState.shader = shaderDictionary[currentState.shaderFullName];

				}
				if (currentState.blendMode_updated)
				{
					dumpit = true;				
				}
				
				if (dumpit)
				{
				TestUploadTexture(_tx);
					DumpCurrentList();
				}
				
				if (currentState.shader_updated)
				{
					shaderUpdateCount++;
					currentState.shader_updated = false;
					context3D.setProgram(currentState.shader.program);
				}
				if (currentState.blendMode_updated)
				{
					currentState.blendMode_updated = false;
					if (currentState.blendMode == BLENDMODE_ALPHA)
					{
						context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);			
					}
					else if (currentState.blendMode == BLENDMODE_SOLID)
					{
						context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);			
					}
				}
			}
			
			static function TestUploadTexture(_tx:s3dTex)
			{
				if (Game.loadTextureFiles == false) return;

				if (_tx != null)
				{
					var tp:TexturePage = TexturePages.pages[_tx.id];
					if (tp.beenUploaded == false)
					{
						if (_tx.texture != null)
						{
					_tx.texture.uploadCompressedTextureFromByteArray(_tx.byteArray, 0,false);
		//					_tx.byteArray = null;
							tp.beenUploaded = true;
						}
						else
						{
						var aaaaa:int = 0;
						}
					}
				}
			}
		
		}
		
		
		
		if (PROJECT::useStage3D)
		{
			

		public static function MakeTriangleList(_indices:Vector.<uint>, _vertices:Vector.<Number>, _verticesExtra:Vector.<Number>, ct:ColorTransform = null)
		{
		}
		public static function RenderTriangleList(m:Matrix3D, _tx:s3dTex, _indices:Vector.<uint>, _vertices:Vector.<Number>, _verticesExtra:Vector.<Number>, ct:ColorTransform = null)
		{

			TestDumpCurrentList(_tx);
			currentState.tx = _tx;
			
			var col:uint = 0x7f7f7f7f;
			if (ct != null)
			{
				var r:uint = (128 * ct.redMultiplier);
				var g:uint = (128 * ct.greenMultiplier);
				var b:uint = (128 * ct.blueMultiplier);
				var alpha:uint =  (128 * ct.alphaMultiplier);
				col = 0x00000000 | (alpha<<24) | (b << 16) | (g << 8) | r;
			}
			
			
			var vse:Vector.<Number> = _verticesExtra;
			var vs:Vector.<Number> = _vertices;
			var ts:Vector.<uint> = _indices;

			var currentV:int = current_vertex_index;
			var currentI:int = current_index_index;
			
			var len:int =  _vertices.length / 3;
			
			m.transformVectors(_vertices, transformedVerts);
			
			var mempos:int = verticesBA.position;
			
			
			var vv:int = 0;
			var cnt0:int = 0;
			for (var a:int = 0; a < len; a++)
			{
				if (useFastMem)
				{
					fastmem.fastSetFloat(transformedVerts[cnt0++], mempos);
					mempos += 4;
					fastmem.fastSetFloat(transformedVerts[cnt0++], mempos);
					mempos += 4;
						cnt0++;
					fastmem.fastSetFloat(vse[vv++], mempos);
					mempos += 4;
					fastmem.fastSetFloat(vse[vv++], mempos);
					mempos += 4;
					fastmem.fastSetI32(col, mempos);
					mempos += 4;
				}
					
				else
				{
					verticesBA.writeFloat(transformedVerts[cnt0++]);
					verticesBA.writeFloat(transformedVerts[cnt0++]);
					cnt0++;
					
					verticesBA.writeFloat(vse[vv++]);
					verticesBA.writeFloat(vse[vv++]);
					//verticesBA.writeFloat(0);
					verticesBA.writeInt(col);
					mempos += 20;
				}
				vv += 3;
				currentV += 5;				
			}
			
			if (useFastMem)
			{
			verticesBA.position = mempos;
			}
			
			
			var offset:int = (batch_start_vertex_index + current_vertex_index) / vert_size;
			var len:int = _indices.length;
			for (var a:int = 0; a < len; a++)
			{
				indicesBA.writeShort( ts[a] + offset);
				currentI++;
//				indices[currentI++] = ts[a]+offset;
			}
			current_vertex_index = currentV;
			current_index_index = currentI;

			totalCount++;
			
			
		}
		}
		
		
		if (PROJECT::useStage3D)
		{
		public static function RenderPreUploadedTriangleList(x:Number,y:Number,m:Matrix3D, _tx:s3dTex, triList:s3dTriList,dof:DisplayObjFrame)
		{
			if (pauseRender) return;
			
			TestDumpCurrentList(_tx);
			currentState.tx = _tx;
			
			SetCurrentTexture();
			
			positionVector[0] = x;
			positionVector[1] = y;
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, positionVector);
			
			texClampVector[0] = dof.u0;
			texClampVector[1] = dof.v0;
			texClampVector[2] = (dof.u1 - dof.u0);
			texClampVector[3] = (dof.v1 - dof.v0);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5,texClampVector);
			
			
			context3D.setVertexBufferAt(0, triList.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // register "0" now contains x,y,z
			context3D.setVertexBufferAt(1, triList.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // register 1 now contains u,v
			context3D.setVertexBufferAt(2, triList.vertexBuffer, 4, Context3DVertexBufferFormat.BYTES_4); 
			
			context3D.drawTriangles(triList.indexBuffer); // Draw the triangle according to the indexBuffer instructio	

			positionVector[0] = 0;
			positionVector[1] = 0;
			positionVector[2] = 1;
			positionVector[3] = 1;
//			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4,positionVector);
			
		}
		
		
		public static function RenderPreUploadedTriangleList1(x:Number,y:Number,m:Matrix3D, _tx:s3dTex, triList:s3dTriList)
		{

			if (pauseRender) return;
			
			TestDumpCurrentList(_tx);
			currentState.tx = _tx;
			
			SetCurrentTexture();
			
			positionVector[0] = 0;	// x;
			positionVector[1] = 0;	// y;
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, positionVector);
			
			RotScaleMatrix.copyFrom(m);
			UploadRotScaleMatrix();
			
			context3D.setVertexBufferAt(0, triList.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // register "0" now contains x,y,z
			context3D.setVertexBufferAt(1, triList.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // register 1 now contains u,v
			context3D.setVertexBufferAt(2, triList.vertexBuffer, 4, Context3DVertexBufferFormat.BYTES_4); 
			
			context3D.drawTriangles(triList.indexBuffer); // Draw the triangle according to the indexBuffer instructio	

			positionVector[0] = 0;
			positionVector[1] = 0;
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, positionVector);
			UploadIdentityRotScaleMatrix();
//			context3D.setProgram(program1);
			
		}
		
		public static function RenderPreUploadedTriangleList1_WithRange(x:Number,y:Number,m:Matrix3D, _tx:s3dTex, triList:s3dTriList,_firstIndex:int,_numTris:int)
		{
			if (pauseRender) return;
			
			TestDumpCurrentList(_tx);
			currentState.tx = _tx;
			
			SetCurrentTexture();
			
			positionVector[0] = x;
			positionVector[1] = y;
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, positionVector);
			
			
			context3D.setVertexBufferAt(0, triList.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // register "0" now contains x,y,z
			context3D.setVertexBufferAt(1, triList.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // register 1 now contains u,v
			context3D.setVertexBufferAt(2, triList.vertexBuffer, 4, Context3DVertexBufferFormat.BYTES_4); 
			
		context3D.drawTriangles(triList.indexBuffer,_firstIndex,_numTris); // Draw the triangle according to the indexBuffer instructio	

			positionVector[0] = 0;
			positionVector[1] = 0;
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4,positionVector);
//			context3D.setProgram(program1);
			
		}
		
		}		
		
		
		
		static var totalCount:int = 0;
		static var textureUploadCount = 0;
		static var textureSkipUploadCount  = 0;
			
		static var batch_start_vertex_index:int;
		static var batch_start_index_index:int;
			
		static function SetCurrentTexture()
		{
			if (Game.loadTextureFiles)
			{
				RecordTextureUsage(currentState.tx);
				
				if (currentState.tx != null)
				{

					if (currentState.tx.texture == null)
					{
						currentState.tx.CreateTexture();
					}
					var tp:TexturePage = TexturePages.pages[currentState.tx.id];
					if (tp.beenUploaded == false)
					{
						
						currentState.tx.texture.uploadCompressedTextureFromByteArray(currentState.tx.byteArray, 0,false);
		//					_tx.byteArray = null;
						tp.beenUploaded = true;
					}
				}
			}
			if (currentState.tx != null)
			{
				context3D.setTextureAt(0, currentState.tx.texture);
			}
		}
		
		public static function StartAsyncTextureUploadByPageIndex(id:int)
		{
			if (Game.loadTextureFiles)
			{
				var tp:TexturePage = TexturePages.pages[id];
				if (tp.beenUploaded == false)
				{
					var tx:s3dTex = tp.s3dTexture;
					tx.texture.uploadCompressedTextureFromByteArray(tx.byteArray, 0, true);
					tp.beenUploaded = true;
				}
			}
		}
			
		public static function StartAsyncTextureUpload(tx:s3dTex)
		{
			if (Game.loadTextureFiles)
			{
				var tp:TexturePage = TexturePages.pages[tx.id];
				if (tp.beenUploaded == false)
				{
					tx.texture.uploadCompressedTextureFromByteArray(tx.byteArray, 0, true);
					tp.beenUploaded = true;
				}
			}
		}
		
		public static function DumpCurrentList()
		{
			if (useRingOfBuffers)
			{
				DumpCurrentList_RingOfBuffers();
				return;
			}
			
			textureUploadCount++;
			if (current_vertex_index == 0 || current_index_index == 0) 
			{
				current_vertex_index = 0;
				current_index_index = 0;
				return;
			}
			
			SetCurrentTexture();
			
			var numVerticesToUpload:int = (current_vertex_index) / vert_size;
			fullVertexBuffer.uploadFromByteArray(verticesBA, 0, (batch_start_vertex_index / vert_size), numVerticesToUpload);
			
			var numIndicesToUpload:int = (current_index_index);
			fullIndexBuffer.uploadFromByteArray(indicesBA, 0, batch_start_index_index, numIndicesToUpload);
			
	
			var numTrianglesToDraw:int = (current_index_index) / 3;
			context3D.drawTriangles(fullIndexBuffer,batch_start_index_index,numTrianglesToDraw); // Draw the triangle according to the indexBuffer instructio	
		
			
			
			verticesBA.position = 0;
			indicesBA.position = 0;
			
			batch_start_vertex_index += current_vertex_index;
			batch_start_index_index += current_index_index;
			current_vertex_index = 0;
			current_index_index = 0;
			batch_start_vertex_index = 0;
			batch_start_index_index = 0;
		}
		
		static function DumpCurrentList_CreatingBuffers()
		{
			if (pauseRender) return;
			textureUploadCount++;
			if (current_vertex_index == 0 || current_index_index == 0) 
			{
				current_vertex_index = 0;
				current_index_index = 0;
				return;
			}
			

			
			SetCurrentTexture();
			
			var numVerticesToUpload:int = (current_vertex_index) / vert_size;			
			vertexBuffer = context3D.createVertexBuffer(current_vertex_index/vert_size, vert_size);			
			vertexBuffer.uploadFromByteArray(verticesBA, 0, 0, numVerticesToUpload);

			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // register "0" now contains x,y,z
			context3D.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // register 1 now contains u,v
			context3D.setVertexBufferAt(2, vertexBuffer, 4, Context3DVertexBufferFormat.BYTES_4); 
			
			var numIndicesToUpload:int = (current_index_index);
			indexBuffer = context3D.createIndexBuffer(current_index_index);
			indexBuffer.uploadFromByteArray(indicesBA, 0, 0, numIndicesToUpload);
			
	
			
			context3D.drawTriangles(indexBuffer); // Draw the triangle according to the indexBuffer instructio	
		
			verticesBA.position = 0;
			indicesBA.position = 0;
			
			batch_start_vertex_index += current_vertex_index;
			batch_start_index_index += current_index_index;
			current_vertex_index = 0;
			current_index_index = 0;
			
			batch_start_vertex_index = 0;
			batch_start_index_index = 0;
		}
		
		
		static var ringCurrentBuffer:int;
		static var ringNumBuffers:int = 16;
		static var ringVertexBufferList:Array;
		static var ringIndexBufferList:Array;
		
		static function CreateRingOfBuffers()
		{
			ringCurrentBuffer = 0;
			ringVertexBufferList = new Array();
			ringIndexBufferList = new Array();
			for (var i:int = 0; i < ringNumBuffers; i++)
			{
				var vb:VertexBuffer3D = context3D.createVertexBuffer(vertexBufferSize/vert_size,vert_size);
				var ib:IndexBuffer3D = context3D.createIndexBuffer(indexBufferSize);

				vb.uploadFromByteArray(verticesBA, 0, 0, vertexBufferSize/vert_size);
				ib.uploadFromByteArray(indicesBA, 0, 0, indexBufferSize);
				
				ringVertexBufferList.push(vb);
				ringIndexBufferList.push(ib);
			}
		}
		
		static function DumpCurrentList_RingOfBuffers()
		{
			if (pauseRender) return;
			textureUploadCount++;
			if (current_vertex_index == 0 || current_index_index == 0) 
			{
				current_vertex_index = 0;
				current_index_index = 0;
				return;
			}
			
			
			SetCurrentTexture();

			var vb:VertexBuffer3D = ringVertexBufferList[ringCurrentBuffer];
			var ib:IndexBuffer3D = ringIndexBufferList[ringCurrentBuffer];
			ringCurrentBuffer++;
			if (ringCurrentBuffer >= ringNumBuffers) ringCurrentBuffer = 0;
			
			var numVerticesToUpload:int = (current_vertex_index) / vert_size;	
			
//			vb = context3D.createVertexBuffer(current_vertex_index/vert_size, vert_size);			

			vb.uploadFromByteArray(verticesBA, 0, 0, numVerticesToUpload);

			context3D.setVertexBufferAt(0, vb, 0, Context3DVertexBufferFormat.FLOAT_2); // register "0" now contains x,y,z
			context3D.setVertexBufferAt(1, vb, 2, Context3DVertexBufferFormat.FLOAT_2); // register 1 now contains u,v
			context3D.setVertexBufferAt(2, vb, 4, Context3DVertexBufferFormat.BYTES_4); 
			
			var numIndicesToUpload:int = (current_index_index);
//			ib = context3D.createIndexBuffer(current_index_index);
			ib.uploadFromByteArray(indicesBA, 0, 0, numIndicesToUpload);
			
			var numTrianglesToDraw:int = (current_index_index) / 3;
			context3D.drawTriangles(ib, 0, numTrianglesToDraw); // Draw the triangle according to the indexBuffer instructio	
		
			verticesBA.position = 0;
			indicesBA.position = 0;
			
			batch_start_vertex_index += current_vertex_index;
			batch_start_index_index += current_index_index;
			current_vertex_index = 0;
			current_index_index = 0;
			
			batch_start_vertex_index = 0;
			batch_start_index_index = 0;
		}
		

		public static function MakeIndieTriangleList(pts:Array,uvs:Array):int
		{
			
			var numTris:int = pts.length / 3;
			
			var triList:s3dTriList = new s3dTriList();
			triList.Init(numTris, 3,2);

			var currentV:int = 0;
			var currentVE:int = 0;
			var currentI:int = 0;
			
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
				
				triList.vertices[currentV++] = x0;
				triList.vertices[currentV++] = y0;
				triList.vertices[currentV++] = z;
				triList.vertices_extra[currentVE++] = uv0.x*uvscale;
				triList.vertices_extra[currentVE++] = uv0.y*uvscale;
				triList.vertices_extra[currentVE++] = 1;
				triList.vertices_extra[currentVE++] = 1;
				triList.vertices_extra[currentVE++] = 1;
				
				triList.vertices[currentV++] = x1;
				triList.vertices[currentV++] = y1;
				triList.vertices[currentV++] = z;
				triList.vertices_extra[currentVE++] = uv1.x*uvscale;
				triList.vertices_extra[currentVE++] = uv1.y*uvscale;
				triList.vertices_extra[currentVE++] = 1;
				triList.vertices_extra[currentVE++] = 1;
				triList.vertices_extra[currentVE++] = 1;

				triList.vertices[currentV++] = x2;
				triList.vertices[currentV++] = y2;
				triList.vertices[currentV++] = z;
				triList.vertices_extra[currentVE++] = uv2.x*uvscale;
				triList.vertices_extra[currentVE++] = uv2.y*uvscale;
				triList.vertices_extra[currentVE++] = 1;
				triList.vertices_extra[currentVE++] = 1;
				triList.vertices_extra[currentVE++] = 1;

				
				triList.indices[currentI] = currentI;
				currentI++;
				triList.indices[currentI] = currentI;
				currentI++;
				triList.indices[currentI] = currentI;
				currentI++;
				
				
			}
			
			
			var vse:Vector.<Number> = triList.vertices_extra;
			var vs:Vector.<Number> = triList.vertices;
			var ts:Vector.<uint> = triList.indices;

			var currentV:int = 0;
			var currentI:int = 0;
			
			var len:int =  triList.vertices.length / 3;
			
			var m:Matrix3D = new Matrix3D();
			m.transformVectors(triList.vertices, transformedVerts);
			
			var mempos:int = 0;
			
			triList.vBA = new ByteArray();
			triList.iBA = new ByteArray();
			triList.vBA.endian = Endian.LITTLE_ENDIAN;
			triList.iBA.endian = Endian.LITTLE_ENDIAN; 
			
			var vv:int = 0;
			var cnt0:int = 0;
			for (var a:int = 0; a < len; a++)
			{
				triList.vBA.writeFloat(transformedVerts[cnt0++]);
				triList.vBA.writeFloat(transformedVerts[cnt0++]);
				cnt0++;				
				triList.vBA.writeFloat(vse[vv++]);
				triList.vBA.writeFloat(vse[vv++]);
				triList.vBA.writeInt(0xffffffff);
				vv += 3;
				currentV += 5;				
				mempos += 20;
			}
			
			var offset:int = 0;
			var len:int = triList.indices.length;
			for (var a:int = 0; a < len; a++)
			{
				triList.iBA.writeShort( ts[a] + offset);
				currentI++;
//				indices[currentI++] = ts[a]+offset;
			}
			
			triList.currentV = currentV;
			triList.currentI = currentI;
			triList.CreateAndUploadByteArrays();
			
			
			triangleLists.push(triList);
			return triangleLists.length - 1;
			
		}
		
		
		

		
		public static var currentIndieVertexBuffer:s3dTriList;
		public static var currentIndieVertexBufferIndexOffset:int;
		
		
		public static function FinishCreateDobjVertexBuffer():int
		{
			var triList:s3dTriList = currentIndieVertexBuffer;

			
			var vse:Vector.<Number> = triList.vertices_extra;
			var vs:Vector.<Number> = triList.vertices;
			var ts:Vector.<uint> = triList.indices;

			var currentV:int = 0;
			var currentI:int = 0;
			
			var len:int =  triList.vertices.length / 3;
			
			var m:Matrix3D = new Matrix3D();
			m.transformVectors(triList.vertices, transformedVerts);
			
			var mempos:int = 0;
			
			var vBA:ByteArray = new ByteArray();
			var iBA:ByteArray = new ByteArray();
			vBA.endian = Endian.LITTLE_ENDIAN;
			iBA.endian = Endian.LITTLE_ENDIAN; 
			
			var vv:int = 0;
			var cnt0:int = 0;
			for (var a:int = 0; a < len; a++)
			{
				vBA.writeFloat(transformedVerts[cnt0++]);
				vBA.writeFloat(transformedVerts[cnt0++]);
				cnt0++;				
				vBA.writeFloat(vse[vv++]);
				vBA.writeFloat(vse[vv++]);
				vBA.writeInt(0xffffffff);
				vv += 3;
				currentV += 5;				
				mempos += 20;
			}
			
			var offset:int = 0;
			var len:int = triList.indices.length;
			for (var a:int = 0; a < len; a++)
			{
				iBA.writeShort( ts[a] + offset);
				currentI++;
//				indices[currentI++] = ts[a]+offset;
			}
			
			
			
			var numVerticesToUpload:int = (currentV) / vert_size;			
			triList.vertexBuffer = context3D.createVertexBuffer(currentV/vert_size, vert_size);			
			triList.vertexBuffer.uploadFromByteArray(vBA, 0, 0, numVerticesToUpload);

			var numIndicesToUpload:int = (currentI);
			triList.indexBuffer = context3D.createIndexBuffer(currentI);
			triList.indexBuffer.uploadFromByteArray(iBA, 0, 0, numIndicesToUpload);
			

			vBA = null;
			iBA = null;
			
			var tl:s3dTriList = currentIndieVertexBuffer;
			tl.indices = null;
			tl.vertices = null;
			tl.vertices_extra = null;
			
			triangleLists.push(triList);
			return triangleLists.length - 1;
		}
		public static function StartCreateDobjVertexBuffer()
		{
			currentIndieVertexBuffer = new s3dTriList();
			currentIndieVertexBuffer.Init(0, 0, 0);		
		}
		
		public static function CreateDobjVertexBuffer_GetCurrentIndex():int
		{
			return currentIndieVertexBuffer.indices.length;
		}
		
		
		public static function AppendTriangleListToDobjVertexBuffer(m:Matrix3D, _tx:s3dTex, _indices:Vector.<uint>, _vertices:Vector.<Number>, _verticesExtra:Vector.<Number>, ct:ColorTransform = null)
		{
			var tl:s3dTriList = currentIndieVertexBuffer;
			
			var col:uint = 0xffffffff;
			if (ct != null)
			{
				var r:uint = (255 + ct.redOffset);
				var g:uint =  (255 + ct.greenOffset);
				var b:uint =  (255 + ct.blueOffset);
				var alpha:uint =  (255 + ct.alphaOffset);
				col = 0x00000000 | (alpha<<24) | (b << 16) | (g << 8) | r;
			}
			
			var vse:Vector.<Number> = _verticesExtra;
			var vs:Vector.<Number> = _vertices;
			var ts:Vector.<uint> = _indices;

			var len:int =  _vertices.length / 3;
			
			var offset:int = tl.vertices.length / 3;
			
			m.transformVectors(_vertices, transformedVerts);
			
			
			
			var vv:int = 0;
			var cnt0:int = 0;
			for (var a:int = 0; a < len; a++)
			{
				tl.vertices.push(transformedVerts[cnt0++])
				tl.vertices.push(transformedVerts[cnt0++])
				cnt0++;				
				tl.vertices.push(0.1);
				tl.vertices_extra.push(vse[vv++]);
				tl.vertices_extra.push(vse[vv++]);
				tl.vertices_extra.push(1);
				tl.vertices_extra.push(1);
				tl.vertices_extra.push(1);
				vv += 3;
			}
			
			var len:int = _indices.length;
			for (var a:int = 0; a < len; a++)
			{
				tl.indices.push(ts[a] + offset);
			}
			
		}		
		} //useStage3D

		public static function SetCurrentShader(shaderName:String)
		{
			// normal
			// alphamul
			// colormul
//			if (EngineDebug.mobileTest2) shaderName = "normal";
			
			if (PROJECT::useStage3D)
			{
				currentState.shaderName = shaderName;
			}
		}
		public static function SetCurrentBlendMode(blendMode:int)
		{
//			if (EngineDebug.mobileTest2) blendMode = s3d.BLENDMODE_SOLID;
			
			if (PROJECT::useStage3D)
			{
				currentState.blendMode = blendMode;
			}
		}
		
		
		static function RecordTextureUsage(tx:s3dTex)
		{
			if (recordTextureUsage == false) return;
			var a:Array = perFrameTextureUsage[perFrameTextureUsage.length - 1];
			//a.push(TexturePages.pages[tx.id].);
			a.push(tx.id);
		}
		static function StartRecordTextureUsage()
		{
			if (recordTextureUsage == false) return;
			perFrameTextureUsage.push(new Array());
			
		}
		
	}

}