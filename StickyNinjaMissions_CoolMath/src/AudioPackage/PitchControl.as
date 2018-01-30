package AudioPackage 
{
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	public class PitchControl 
	{
		private const BLOCK_SIZE: int = 2048;	// 2048;
		
		private var _mp3: Sound;
		private var _sound: Sound;
		
		private var _target: ByteArray;
		private var _position: Number;
		private var _rate: Number;
		
		var active:Boolean = false;
		
		public function PitchControl( soundName: String )
		{
			firstTime = true;
			
			active = false;
			
			_target = new ByteArray();

			var classRef:Class = getDefinitionByName(soundName) as Class;
			_mp3 = new classRef() as Sound;

			//_mp3 = new sfx_engine1();
			
			var ba1:ByteArray = new ByteArray();
			ba = new ByteArray();
			_mp3.extract(ba, _mp3.length * 44.1, 0);
			_mp3.extract(ba1, _mp3.length * 44.1, 0);
			
			var i:int;
			ba1.position = 0;
			ba.position = ba.length;
			for (i = 0; i < _mp3.length * 44.1; i++)
			{
				ba.writeByte(ba1.readByte());
			}

			volume = 0;
			
//			trace("ba1 length  " + ba1.length);
//			trace("ba length  " + ba.length);
		
//			trace("mp3  " + _mp3.bytesTotal);
//			trace("mp3 length " + _mp3.length);
//			trace("mp3 numsamples " + _mp3.length * 44.1);

			mp3length = _mp3.length * 44.1;
			
			
//			_mp3.addEventListener( Event.COMPLETE, complete1 );
//			_mp3.play();
//			_mp3.load( new URLRequest( url ) );

//			_mp3 = new Sound();
//			_mp3.addEventListener( Event.COMPLETE, complete );
//			_mp3.load( new URLRequest( url ) );
			
			
			_position = 0.0;
			_rate = 1.0;

			_sound = new Sound();
			_sound.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleData,false,0,true );
//			_sound.addEventListener( Event.COMPLETE, complete );


			_sound.play();


		}


		
		public function StartAgain()
		{
			if (active == false) return;
			_sound = new Sound();
			_sound.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );
			_sound.play();			
		}
		public function Stop()
		{
			_sound.removeEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );

//			_mp3.close();
//			_sound.close();
			_target = null;
			_mp3 = null;
			_sound = null;
			active = false;
			
		}
		
		var firstTime:Boolean;
		var mp3length:int;
		var ba:ByteArray;
		
		public var volume:Number;
		
		public function get rate(): Number
		{
			return _rate;
		}
		
		public function set rate( value: Number ): void
		{
			if( value < 0.0 )
				value = 0;

			_rate = value;
		}

		private function complete( event: Event ): void
		{
			_position = 0 ;
		}

		private function sampleData( event: SampleDataEvent ): void
		{
			//-- REUSE INSTEAD OF RECREATION
			_target.position = 0;
			
			//-- SHORTCUT
			var data: ByteArray = event.data;
			
			var scaledBlockSize: Number = BLOCK_SIZE * _rate;
			var positionInt: int = _position;
			
			
			var alpha: Number = _position - positionInt;

			var positionTargetNum: Number = alpha;
			var positionTargetInt: int = -1;

			//-- COMPUTE NUMBER OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR INTERPOLATION)
			var need: int = Math.ceil( scaledBlockSize ) + 2;
			
			//-- EXTRACT SAMPLES
//			positionInt = 0;
			
			var read:int = need;
			
			var i:int;
			_target.position = 0;
			ba.position = positionInt* 8;
			for (i = 0; i < need; i++)
			{
				_target.writeFloat(ba.readFloat());
				_target.writeFloat(ba.readFloat());
			}
			
			

			var n: int = read == need ? BLOCK_SIZE : read / _rate;

			var l0: Number;
			var r0: Number;
			var l1: Number;
			var r1: Number;
			
			n -= 32;
			
			var v:Number = volume;
			if (Audio.IsMuteSFX()) v = 0;
			


			for( var i: int = 0 ; i < n ; ++i )
			{
				//-- AVOID READING EQUAL SAMPLES, IF RATE < 1.0
				if( int( positionTargetNum ) != positionTargetInt )
				{
					positionTargetInt = positionTargetNum;
					
					//-- SET TARGET READ POSITION
					_target.position = positionTargetInt << 3;
	
					//-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
					l0 = _target.readFloat();
					r0 = _target.readFloat();

					l1 = _target.readFloat();
					r1 = _target.readFloat();
				}
				
				
				data.writeFloat(l0*v);
				data.writeFloat(l1*v);
				
				//-- WRITE INTERPOLATED AMPLITUDES INTO STREAM
//				data.writeFloat( (l0 + alpha * ( l1 - l0 ))*volume );
//				data.writeFloat( (r0 + alpha * ( r1 - r0 ))*volume );
				
				//-- INCREASE TARGET POSITION
				positionTargetNum += _rate;
				
				//-- INCREASE FRACTION AND CLAMP BETWEEN 0 AND 1
				alpha += _rate;
				while( alpha >= 1.0 ) --alpha;
			}
			
			//-- FILL REST OF STREAM WITH ZEROs
			if( i < BLOCK_SIZE )
			{
				while( i < BLOCK_SIZE )
				{
					data.writeFloat( 0.0 );
					data.writeFloat( 0.0 );
					
					++i;
				}
			}

			//-- INCREASE SOUND POSITION
			_position += scaledBlockSize;
			if (_position >= mp3length) _position = 0;
			
//			trace("pos " + _position);
		}
	}
}
