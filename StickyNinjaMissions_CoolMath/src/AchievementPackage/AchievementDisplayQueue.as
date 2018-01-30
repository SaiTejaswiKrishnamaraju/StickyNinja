package AchievementPackage 
{
	import AudioPackage.Audio;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class AchievementDisplayQueue 
	{
		
		public function AchievementDisplayQueue() 
		{
			
		}
		var displayQueue:Vector.<AchievementPopup>;
		
		public function IsDisplayQueueActive():Boolean
		{
			if (displayQueue.length == 0) return false;
			return true;
		}
		public function Update():Boolean
		{
			if (displayQueue.length == 0) return false;
			
			var popup:AchievementPopup = displayQueue[0];
			if (popup.active == false)
			{
				popup.active = true;
				Game.hudController.achievement_inst.Child("text1").SetText(popup.achievement.name.toUpperCase());
				Game.hudController.achievement_inst.gameObj.InitAchievementsPopup(1);
				
				Audio.OneShot("sfx_got_achievement");
			}
			else
			{
//				Game.hudController.achievement_inst.visible = true;
//				Game.hudController.achievement_inst.Child("text1").SetText(popup.achievement.name.toUpperCase());
				
				popup.timer--;
				if (popup.timer == 0)
				{
					Game.hudController.achievement_inst.gameObj.InitAchievementsPopup(2);
				}
				else if (popup.timer < -50)
				{
					popup.active = false;
//					Game.hudController.achievement_inst.visible = false;
					popup.active = false;					
					displayQueue.splice(0, 1);
				}
			}
			return true;
		}
		public function AddUnlockedList(unlockedList:Vector.<Achievement>)
		{
			for each(var ach:Achievement in unlockedList)
			{
				var popup:AchievementPopup = new AchievementPopup();
				popup.achievement = ach;
				popup.timer = Defs.fps * 3;
				popup.active = false;
				displayQueue.push(popup);				
			}
		}
		function Reset()
		{
			displayQueue = new Vector.<AchievementPopup>();
		}
		
	}

}