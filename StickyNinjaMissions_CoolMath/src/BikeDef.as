package  
{
	/**
	 * ...
	 * @author 
	 */
	public class BikeDef 
	{
		
		public var wheel0_x:Number;
		public var wheel0_y:Number;
		public var wheel0_index:int;
		public var wheel0_depth:int;
		public var wheel0_scale:Number;
		public var wheel1_x:Number;
		public var wheel1_y:Number;
		public var wheel1_index:int;
		public var wheel1_depth:int;
		public var wheel1_scale:Number;
		
		
		public var frame_depth:int;
		
		public var susp0_len:Number;
		public var susp0_ang:Number;
		public var susp0_freq:Number;
		public var susp1_len:Number;
		public var susp1_ang:Number;
		public var susp1_freq:Number;
		
		
		public var accel:Number;
		public var maxVel:Number;
		public var inputTorqueAccel:Number;
		public var maxInputTorqueVel:Number;
		public var maxRotVel:Number;
		
		public var name:String;
		public var displayName:String;
		public var frameIndex:int;
		public var index:int;
		public var specialStunt:int;
		public var inv:InventoryItem;
		
		public function Export():String
		{
			var s:String = "";
			s += "\t\t\tlist["+index+"].Setup(";
			s += '"'+name+'"' +",";
			s += '"'+displayName+'"' +",";
			s += frameIndex +",";
			s += specialStunt +",";
			s += inputTorqueAccel +",";
			s += maxInputTorqueVel +",";
			s += accel +",";
			s += maxVel +",";
			s += maxRotVel +",";
			s += wheel0_x +",";
			s += wheel0_y +",";
			s += wheel0_index +",";
			s += wheel0_depth +",";
			s += wheel0_scale +",";
			s += wheel1_x +",";
			s += wheel1_y +",";
			s += wheel1_index +",";
			s += wheel1_depth +",";
			s += wheel1_scale +",";
			s += frame_depth +",";
			s += susp0_len +",";
			s += susp0_ang +",";
			s += susp0_freq +",";
			s += susp1_len +",";
			s += susp1_ang +",";
			s += susp1_freq +");";
			return s;
		}

		public function ExportXML():String
		{
			var s:String = "";
			s += '<bikedef index="' + index + '" ';
			s += 'name="' + name + '" ';
			s += 'displayName="' + displayName + '" ';
			s += 'frameIndex="' + frameIndex + '" ';
			s += 'specialStunt="' + specialStunt + '" ';
			s += 'frame_depth="' + frame_depth + '" ';
			s += '\n\t';
			s += 'inputTorqueAccel="' + inputTorqueAccel + '" ';
			s += 'maxInputTorqueVel="' + maxInputTorqueVel + '" ';
			s += 'accel="' + accel + '" ';
			s += 'maxVel="' + maxVel + '" ';
			s += 'maxRotVel="' + maxRotVel + '" ';
			s += '\n\t';
			s += 'wheel0_x="' + wheel0_x + '" ';
			s += 'wheel0_y="' + wheel0_y + '" ';
			s += 'wheel0_index="' + wheel0_index + '" ';
			s += 'wheel0_depth="' + wheel0_depth + '" ';
			s += 'wheel0_scale="' + wheel0_scale + '" ';
			s += '\n\t';
			s += 'wheel1_x="' + wheel1_x + '" ';
			s += 'wheel1_y="' + wheel1_y + '" ';
			s += 'wheel1_index="' + wheel1_index + '" ';
			s += 'wheel1_depth="' + wheel1_depth + '" ';
			s += 'wheel1_scale="' + wheel1_scale + '" ';
			s += '\n\t';
			s += 'susp0_len="' + susp0_len + '" ';
			s += 'susp0_ang="' + susp0_ang + '" ';
			s += 'susp0_freq="' + susp0_freq + '" ';
			s += '\n\t';
			s += 'susp1_len="' + susp1_len + '" ';
			s += 'susp1_ang="' + susp1_ang + '" ';
			s += 'susp1_freq="' + susp1_freq + '" ';
			s += ' />';
			s += '\n';
			s += '\n';
			return s;
		}
		
		
		public function InitFromXML(x:XML)
		{
			name = XmlHelper.GetAttrString(x.@name);
			displayName =  XmlHelper.GetAttrString(x.@displayName);
			frameIndex =  XmlHelper.GetAttrInt(x.@frameIndex);
			specialStunt = XmlHelper.GetAttrInt(x.@specialStunt);
			
			inputTorqueAccel = XmlHelper.GetAttrNumber(x.@inputTorqueAccel);
			maxInputTorqueVel = XmlHelper.GetAttrNumber(x.@maxInputTorqueVel);
			maxRotVel = XmlHelper.GetAttrNumber(x.@maxRotVel);
			accel = XmlHelper.GetAttrNumber(x.@accel);
			maxVel = XmlHelper.GetAttrNumber(x.@maxVel);
			
			wheel0_x =XmlHelper.GetAttrNumber(x.@wheel0_x);
			wheel0_y =XmlHelper.GetAttrNumber(x.@wheel0_y);
			wheel0_index = XmlHelper.GetAttrInt(x.@wheel0_index);
			wheel0_depth = XmlHelper.GetAttrNumber(x.@wheel0_depth);
			wheel0_scale = XmlHelper.GetAttrNumber(x.@wheel0_scale);
			wheel1_x = XmlHelper.GetAttrNumber(x.@wheel1_x);
			wheel1_y = XmlHelper.GetAttrNumber(x.@wheel1_y);
			wheel1_index =XmlHelper.GetAttrInt(x.@wheel1_index);
			wheel1_depth = XmlHelper.GetAttrNumber(x.@wheel1_depth);
			wheel1_scale = XmlHelper.GetAttrNumber(x.@wheel1_scale);
			frame_depth = XmlHelper.GetAttrInt(x.@frame_depth);
			susp0_len = XmlHelper.GetAttrNumber(x.@susp0_len);
			susp0_ang = XmlHelper.GetAttrNumber(x.@susp0_ang);
			susp0_freq = XmlHelper.GetAttrNumber(x.@susp0_freq);
			susp1_len = XmlHelper.GetAttrNumber(x.@susp1_len);
			susp1_ang = XmlHelper.GetAttrNumber(x.@susp1_ang);
			susp1_freq = XmlHelper.GetAttrNumber(x.@susp1_freq);
		
		}
		
		public function Setup(n:String, dn:String, f:int, _specialStunt:int,						
						_itorq:Number,_maxitorq:Number,_accel:Number,_maxVel:Number,_maxRotVel:Number,
						w0x:Number, w0y:Number, w0i:int, w0d:int, w0s:Number,
						w1x:Number, w1y:Number, w1i:int, w1d:int,w1s:Number,
						fd:int,
						s0l:Number,s0a:Number,s0f:Number,
						s1l:Number, s1a:Number, s1f:Number)
		{
			
			name = n;
			displayName = dn;
			frameIndex = f;
			specialStunt = _specialStunt;
			
			inputTorqueAccel = _itorq;
			maxInputTorqueVel = _maxitorq;
			maxRotVel = _maxRotVel;
			accel = _accel;
			maxVel = _maxVel;
			
			wheel0_x = w0x;
			wheel0_y = w0y;
			wheel0_index = w0i;
			wheel0_depth = w0d;
			wheel0_scale = w0s;
			wheel1_x = w1x;
			wheel1_y = w1y;
			wheel1_index = w1i;
			wheel1_depth = w1d;
			wheel1_scale = w1s;
			frame_depth = fd;
			susp0_len = s0l;
			susp0_ang = s0a;
			susp0_freq = s0f;
			susp1_len = s1l;
			susp1_ang = s1a;
			susp1_freq = s1f;
			
//			inv = Inventory.SetupNewItem("bike_" + name, "bike", displayName);
//			inv.bikeDef = this;
			
			
		}
		public function BikeDef() 
		{
			
			wheel0_x = -24;
			wheel0_y = 6;
			wheel0_index = 0;

			wheel1_x = 27;
			wheel1_y = 3;
			wheel1_index = 0;
			
			susp0_len = 10;
			susp0_ang = 30;
			susp0_freq = 10;

			susp1_len = 10;
			susp1_ang = -20;
			susp1_freq = 10;
			
			frameIndex = 0;
			
			wheel0_scale = 1;
			wheel1_scale = 1;
			
			inputTorqueAccel = 100;
			maxInputTorqueVel = 1000;
			maxRotVel = 4;
			maxVel = 700;
			accel = 30;
		}
		
	}

}