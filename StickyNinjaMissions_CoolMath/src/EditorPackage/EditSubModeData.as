package EditorPackage 
{
	/**
	 * ...
	 * @author ...
	 */
	public class EditSubModeData 
	{
		var name:String;
		var displayName:String;
		var keyCode:int;
		var setMode:Boolean
		
		public function EditSubModeData(_name:String,_setMode:Boolean,_keyCode:int,_displayName:String) 
		{
			name = _name;
			keyCode = _keyCode;
			displayName = _displayName;
			setMode = _setMode;
		}
		
	}

}