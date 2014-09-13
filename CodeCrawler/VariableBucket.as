package  
{
	/**
	 * ...
	 * @author Swifty
	 */
	public class VariableBucket extends Item
	{
		[Embed (source = "")] private static var sprite:Class;
		
		public var name:String;
		public var value:Constant;
		
		public function VariableBucket(name:String, value:Constant, x:int, y:int) {
			super(x, y);
			loadGraphic(sprite);
			this.name = name;
			this.value = value;
		}
		
		public function isEmpty():Boolean {
			return this.value == null;
		}
		
		override public function getDescription():String {\
			var value_string:String;
			if (value == null) {
				value_string = "None";
			}
			else {
				value_string = value.toString();
			}
			return "Variable " + name + " = " + value_string;
		}
		
		public function cloneAtEmpty(new_x:int, new_y:int):Item {
			return new VariableBucket(this.name, null, new_x, new_y);
		}
		
		override public function cloneAt(new_x:int, new_y:int):Item {
			if (value == null)
				return new VariableBucket(this.name, null, new_x, new_y);
			else
				return new VariableBucket(this.name, value.cloneAt(new_x, new_y), new_x, new_y);
		}
		
		override public function toString():String {
			var value_string:String;
			if (value == null) {
				value_string = "None";
			}
			else {
				value_string = value.toString();
			}
			return "var " + name + " = " + value_string;
		}
	}

}