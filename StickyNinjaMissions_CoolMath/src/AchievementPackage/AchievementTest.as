package AchievementPackage 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class AchievementTest
	{
		var functionName:String;
		var functionParams:String;
		
		//var precalcedParamNames:Array;
		//var precalcedParamValues:Array;
		var precalcedParamDictionary:Dictionary;
		
		public function AchievementTest() 
		{
			
		}
		
		// make copies of stored arrays.
		public function PreCalc()
		{
			Utils.GetParams(functionParams);
			
			precalcedParamDictionary = new Dictionary();
			for (var key:Object in Utils.paramDictionary) 
			{
				precalcedParamDictionary[key] = Utils.paramDictionary[key];
			}
			
			/*
			precalcedParamNames = new Array();
			for each(var s:String in Utils.paramNames)
			{
				precalcedParamNames.push(s);
			}
			
			precalcedParamValues = new Array();
			for each(var s:String in Utils.paramValues)
			{
				precalcedParamValues.push(s);
			}
			*/
		}
		
	}

}