package AudioPackage 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author ...
	 */
	public class Audio 
	{
		static var soundDefs:Vector.<SoundEffectDef>;
		static var activeSounds:Vector.<ActiveSoundEffectItem>;
		
		public static var muteSFX:Boolean;
		public static var muteMusic:Boolean;
		
		static var soundAllowed:Boolean;
		
		static var isInitialised:Boolean = false;		// to stop button clicks etc. on preloader
		
		
		public function Audio() 
		{
			
		}
		
		
		
		public static function InitOnce()
		{
			isInitialised = true;
			soundAllowed = true;
			muteSFX = false;
			muteMusic = false;
			playingLocalFile = false;
			
			if(PROJECT::isWalkthrough)
			{
				muteSFX = true;
				muteMusic = true;
			}
			
			soundDefs = new Vector.<SoundEffectDef>();
			activeSounds = new Vector.<ActiveSoundEffectItem>();
			for (var i:int = 0; i < 32; i++)
			{
				activeSounds.push(new ActiveSoundEffectItem());
			}

			// Test to see if sound is available
			var s:Sound = new sfx_click();
			var sc:SoundChannel = s.play(0, 0,new SoundTransform(0,0));			
			if(sc == null)			
			{
				soundAllowed = false;
				muteSFX = true;
				muteMusic = true;
			}
			


AddSound("sfx_beep");
AddSound("sfx_click");
AddSound("sfx_crash1");
AddSound("sfx_crash2");
AddSound("sfx_crash3");
AddSound("sfx_crash4");
AddSound("sfx_crash5");
AddSound("sfx_land1");
AddSound("sfx_land2");
AddSound("sfx_land3");
AddSound("sfx_turboboost");
AddSound("sfx_pickup_nitro");
AddSound("sfx_tick");
AddSound("sfx_jump");
AddSound("sfx_won_race");


			
		}
		
		public static function IsMuteSFX():Boolean 
		{
			return muteSFX;
		}
		public static function ToggleMuteSFX():void 
		{
			if (soundAllowed == false)
			{
				muteSFX = true;
				return;
			}
			
			muteSFX = (muteSFX == false);
			if (muteSFX)
			{
				MuteAll(false);
			}
			else
			{
				UnMuteAll(false);
			}
		}

		public static function IsMuteMusic():Boolean 
		{
			return muteMusic;
		}
		public static function ToggleMuteMusic():void 
		{
			if (soundAllowed == false)
			{
				muteMusic = true;
				return;
			}
			muteMusic = (muteMusic == false);
			if (muteMusic)
			{
				MuteAll(true);
			}
			else
			{
				UnMuteAll(true);
			}
		}
		
		
		static function GetSoundDefByName(name:String)
		{
			for each(var def:SoundEffectDef in soundDefs)
			{
				if (def.name == name)
				{
					return def;
				}
			}
			return AddSound(name);
		}

		
		static function AddSound(_soundName:String):SoundEffectDef
		{		
			
			var classRef:Class;
			
			try
			{
				classRef = getDefinitionByName(_soundName) as Class;
			}
			catch(e:Object)
			{
				classRef = null;
			}
			
			if (classRef == null)
			{
				//Utils.traceerror("Audio AddSound Error: Can't find sound " + _soundName);
				return null;
			}
			else
			{
				var s:Sound = new classRef() as Sound;
				var def:SoundEffectDef = new SoundEffectDef();
				def.name = _soundName;
				def.looped = false;
				def.flashSound = s;
				
				soundDefs.push(def);
				return def;
			}
			return null;
		}
		
		
		static function GetFreeActiveSound():ActiveSoundEffectItem
		{
			for each(var act:ActiveSoundEffectItem in activeSounds)
			{
				if (act.active == false)
				{
					act.ResetData();
					return act;
				}
			}
			return null;
		}
		
		static function GetActiveMusic():ActiveSoundEffectItem
		{
			for each(var act:ActiveSoundEffectItem in activeSounds)
			{
				if (act.active && act.isMusic)
				{
					return act;
				}
			}
			return null;
		}
		
		
		static function GetActiveSoundByName(_name:String):ActiveSoundEffectItem
		{
			for each(var act:ActiveSoundEffectItem in activeSounds)
			{
				if (act.active && act.name == _name)
				{
					return act;
				}
			}
			return null;
		}
		
		public static function SetSoundVolume(name:String, volume:Number)
		{
			var activeAct:ActiveSoundEffectItem = GetActiveSoundByName(name);
			if (activeAct == null) return;
			activeAct.SetVolume(volume);
		}

		public static function SetSoundPan(name:String, pan:Number)
		{
			var activeAct:ActiveSoundEffectItem = GetActiveSoundByName(name);
			if (activeAct == null) return;
			activeAct.SetPan(pan);
		}
		
		
		static function SetCurrentMusicToFadeOut()
		{
			for each(var act:ActiveSoundEffectItem in activeSounds)
			{
				if (act.active && act.isMusic)
				{
					act.StartFadeOut();
				}
			}
		}
		
		
		public static function StopMusic()
		{
			SetCurrentMusicToFadeOut();
		}
		public static function PlayMusic(name:String,volume:Number = 0.3,_loop:Boolean=true)
		{
			if (IsMuteMusic()) return;
			if (playingLocalFile) return;
			
			var def:SoundEffectDef = GetSoundDefByName(name);
			if (def == null) return;
			
			// already playing?
			var activeAct:ActiveSoundEffectItem = GetActiveSoundByName(name);
			if (activeAct != null) return;
			
			SetCurrentMusicToFadeOut();
			
			var act:ActiveSoundEffectItem = GetFreeActiveSound();
			if (act != null)
			{
				var st:SoundTransform = new SoundTransform();
				st.volume = volume;
				st.pan = 0;
				var sc:SoundChannel;
				if (_loop)
				{
					 sc = def.flashSound.play(0, 9999999999, st);			
				}
				else
				{
					sc = def.flashSound.play(0, 0, st);			
				}
				act.StartMusic(name, sc);
			}
			
		}
		
		public static function Loop(name:String, numLoops:int,pan:Number = 0,volume:Number=1,unique:Boolean = true)
		{
			if (IsMuteSFX()) return;
			
			var def:SoundEffectDef = GetSoundDefByName(name);
			
			if (unique)
			{
				var activeAct:ActiveSoundEffectItem = GetActiveSoundByName(name);
				if (activeAct != null) return;
			}
			
			var act:ActiveSoundEffectItem = GetFreeActiveSound();
			if (act != null)
			{
				var st:SoundTransform = new SoundTransform();
				st.volume = volume;
				st.pan = pan;
				var sc:SoundChannel = def.flashSound.play(0, numLoops, st);			
				act.StartSFX(name, sc);
			}			
		}
		
		public static function StartPitchControlSound(name:String,volume:Number = 0.3,unique:Boolean = true)
		{
			var def:SoundEffectDef = GetSoundDefByName(name);
			
			if (unique)
			{
				var activeAct:ActiveSoundEffectItem = GetActiveSoundByName(name);
				if (activeAct != null) 
				{
//					trace("StartPitchControlSound already active " + name);
					return;
				}
			}
			
			var act:ActiveSoundEffectItem = GetFreeActiveSound();
			if (act != null)
			{
				var st:SoundTransform = new SoundTransform();
//				trace("StartPitchControlSound started");
				act.StartPitchControlSound(name,null,volume);
				act.volume = volume;
				act.sc = new SoundChannel();
				st.volume = volume;
				st.pan = 0;
				act.sc.soundTransform = st;
				
			}
			
		}
		
		public static function OneShot_Random(names:Array, pan:Number = 0, volume:Number = 1 )
		{
			var r:int = Utils.RandBetweenInt(0, names.length - 1);
			OneShot(names[r], pan, volume);
		}
		
		public static function OneShot(name:String, pan:Number = 0,volume:Number=1 )
		{
			if (isInitialised == false) return;
			if (IsMuteSFX()) return;
			var def:SoundEffectDef = GetSoundDefByName(name);
			if (def == null) return;
			
			var st:SoundTransform = new SoundTransform();
			st.volume = volume;
			st.pan = pan;
			def.flashSound.play(0, 0, st);
				
		}
		
		
		public static function SetSoundPitch(name:String, pitch:Number)
		{
			for each(var act:ActiveSoundEffectItem in activeSounds)
			{
				if (act.active && act.isPitchControl && act.name == name)
				{
					act.pitchControl.rate = pitch;
				}
			}						
		}
		
		
		public static var activeMusicList:Array = null;
		
		public static function UnPauseEverything()
		{
			if (activeMusicList == null) return;
			for each(var actName in activeMusicList)
			{
				PlayMusic(actName);
			}			
			activeMusicList = null;
		}
		public static function PauseEverything()
		{
			StopAllSFX();
			
			activeMusicList = new Array();
			for each(var act:ActiveSoundEffectItem in activeSounds)
			{
				if (act.active && act.isMusic)
				{
					activeMusicList.push(act.name);
					act.Stop();
				}
			}			
			
		}
		
		public static function StopSFX(name:String):void
		{
			var activeAct:ActiveSoundEffectItem = GetActiveSoundByName(name);
			if (activeAct == null) return;
			activeAct.Stop();
		}
		
		public static function StopAllSFX():void
		{
			for each(var act:ActiveSoundEffectItem in activeSounds)
			{
				if (act.active && act.isMusic==false )
				{
					act.Stop();
				}
			}			
		}
		public static function StopAllMusic():void
		{
			for each(var act:ActiveSoundEffectItem in activeSounds)
			{
				if (act.active && act.isMusic)
				{
					act.Stop();
				}
			}			
		}
		public static function UpdateOncePerFrame():void
		{
			for each(var act:ActiveSoundEffectItem in activeSounds)
			{
				if (act.active)
				{
					act.UpdateOncePerFrame();
				}
			}
			
		}
		
		public static function MuteAll(_isMusic:Boolean):void
		{
			for each(var act:ActiveSoundEffectItem in activeSounds)
			{
				if (act.active)
				{
					if (act.isMusic == _isMusic)
					{
						act.Mute();
					}
				}
			}
			
		}
		public static function UnMuteAll(_isMusic:Boolean):void
		{
			for each(var act:ActiveSoundEffectItem in activeSounds)
			{
				if (act.active)
				{
					if (act.isMusic == _isMusic)
					{
						act.UnMute();
					}
				}
			}
			
		}
		
//------------------------------------------------------------------------------------------------------------------

		static var loadedMP3:Sound;
		static var loadedSoundChannel:SoundChannel;
		static var playingLocalFileCallback:Function;
		public static var playingLocalFile:Boolean;
		static var fr:FileReference;
		
		public static function StopLocalFilePlayback()
		{
			if (playingLocalFile == false) return;
			if (loadedMP3 != null && loadedSoundChannel != null)
			{
				trace("stopping local file playback");
				loadedSoundChannel.stop();
			}
		}
		
		public static function DontPlayLocalAnyMore()
		{
			StopLocalFilePlayback();
			playingLocalFile = false;
			loadedMP3 = null;
			loadedSoundChannel = null;
		}
		public static function PlayLocalFile(callback:Function)
		{
			playingLocalFileCallback = callback;
			var ff:FileFilter = new FileFilter("MP3 files", "*.mp3");
			fr = new FileReference();
			var loader:URLLoader = new URLLoader();
			fr.addEventListener(Event.SELECT, selectHandler);
			fr.addEventListener(Event.CANCEL, cancelHandler);
			fr.browse(new Array(ff));
		}
		static function cancelHandler(e:Event)
		{
			trace("cancelled");
			if (playingLocalFileCallback != null) playingLocalFileCallback();
		}
		static function selectHandler(e:Event)
		{
			var frl:MP3FileReferenceLoader = new MP3FileReferenceLoader();
			
			frl.addEventListener(MP3SoundEvent.COMPLETE,MP3Loaded);
			frl.getSound(fr);
			
			
//            fr.addEventListener(Event.COMPLETE, completeHandler);
//			fr.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
//			fr.load();
//			trace("select handler");
//			trace(e.currentTarget);
			
		}
		static function MP3Loaded(e:MP3SoundEvent)
		{
			StopAllMusic();
			StopLocalFilePlayback();
			
			loadedMP3 = e.sound;

			loadedSoundChannel = loadedMP3.play(0, 99999999);
			trace("MP3Loaded");
			
			playingLocalFile = true;
			
			if (playingLocalFileCallback != null) playingLocalFileCallback();
		}
		static function onLoadError(e:Event)
		{
			trace("load error");
			if (playingLocalFileCallback != null) playingLocalFileCallback();
			
		}
		static function completeHandler(e:Event)
		{
			trace("complete handler");
			if (playingLocalFileCallback != null) playingLocalFileCallback();
			
			var data:ByteArray = fr.data;
			trace("bytearray length " + data.length);
			StopAllMusic();
			
			var mp3:Sound = new Sound();
			mp3.extract(data, 10000);	// data.length * 44.1);
			mp3.play(0, 999999);
			

		}
		
		
	}

}