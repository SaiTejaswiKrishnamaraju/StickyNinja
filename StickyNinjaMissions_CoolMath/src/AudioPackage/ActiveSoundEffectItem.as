package AudioPackage 
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author ...
	 */
	public class ActiveSoundEffectItem 
	{
		// an active sound effect.
		
		var active:Boolean;
		var sc:SoundChannel;
		var name:String;
		var st:SoundTransform;
		var volume:Number;
		var isMusic:Boolean;
		var isPitchControl:Boolean;
		var fadeVel:Number = 0;
		var fadeLevel:Number = 1;
		var pitchControl:PitchControl = null;
		
		public function ActiveSoundEffectItem() 
		{
			ResetData();
		}
		
		public function ResetData()
		{
			sc = null;
			st = null;
			name = "";
			active = false;
			isPitchControl = false;
			isMusic = false;
			fadeLevel = 1;
			fadeVel = 1;
			pitchControl = null;			
		}
		
		
		public function StartPitchControlSound(_name:String, _sc:SoundChannel=null,volume:Number = 1)
		{
			sc = _sc;
			name = _name;
			active = true;
			isMusic = false;
			isPitchControl = true;
			
			pitchControl = new PitchControl(_name);
			pitchControl.active = true;
			pitchControl.volume = volume;
		}
		
		
		public function StartSFX(_name:String, _sc:SoundChannel)
		{
			sc = _sc;
			name = _name;
			sc.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
			volume = sc.soundTransform.volume;
			
			st = sc.soundTransform;
			
			st.volume = 0;
			if (Audio.muteSFX == false)
			{
				st.volume = volume * fadeLevel;
			}
			sc.soundTransform = st;
			
			active = true;
			isMusic = false;
		}

		public function StartMusic(_name:String, _sc:SoundChannel)
		{
			sc = _sc;
			name = _name;
			sc.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
			volume = sc.soundTransform.volume;
			
			st = sc.soundTransform;
			fadeLevel = 0;
			
			StartFadeIn();
			
			st.volume = 0;
			if (Audio.muteMusic == false)
			{
				st.volume = volume * fadeLevel;
			}
			sc.soundTransform = st;
			
			active = true;
			isMusic = true;
			
		}
		
		
		function soundCompleteHandler(e:Event)
		{
			Stop();
		}
		
		function Stop()
		{
			if (active)
			{
				if (isPitchControl)
				{
					if (pitchControl)
					{
						pitchControl.Stop();
						pitchControl = null;
					}
				}
				if (sc != null)
				{
					sc.stop();
					sc.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
					sc = null;
				}
				active = false;
				name = "";			
			}
		}
		function Mute()
		{			
			st = sc.soundTransform;
			volume = st.volume;
			st.volume = 0;
			sc.soundTransform = st;		
			
			if (isPitchControl)
			{
				pitchControl.volume = 0;
			}
			
		}
		
		function UnMute()
		{			
			st = sc.soundTransform;
			st.volume = volume;
			sc.soundTransform = st;			

			if (isPitchControl)
			{
				pitchControl.volume = volume;
			}
		}
		
		function UpdateVolume()
		{
			if (isPitchControl)
			{
				return;
			}
			st = sc.soundTransform;
			if (Audio.muteSFX == false)
			{
				st.volume = volume * fadeLevel;
				sc.soundTransform = st;
			}
		}
		function SetVolume(_volume:Number)
		{
			st = sc.soundTransform;
			volume = _volume;
			
			if (Audio.muteSFX == false)
			{
				st.volume = volume * fadeLevel;
				sc.soundTransform = st;
			}
			if (isPitchControl)
			{
				//if (pitchControl != null)
				//{
					pitchControl.volume = volume * fadeLevel;
				//}
			}
		}
		
		function SetPan(pan:Number)
		{
			st = sc.soundTransform;
			st.pan = pan;
			sc.soundTransform = st;
		}
		
		function StartFadeOut()
		{
			fadeVel = -0.05;
		}
		function StartFadeIn()
		{
			fadeVel = 0.05;
		}

		
		public function UpdateOncePerFrame():void
		{
			if (fadeVel < 0)
			{
				fadeLevel += fadeVel;
				UpdateVolume();
				if (fadeLevel <= 0)
				{
					fadeVel = 0;
					fadeLevel = 0;
					this.Stop();
				}
			}
			else if (fadeVel > 0)
			{
				fadeLevel += fadeVel;
				UpdateVolume();
				if (fadeLevel >= 1)
				{
					fadeLevel = 1;
					fadeVel = 0;
				}
				
			}
		}

		
	}

}