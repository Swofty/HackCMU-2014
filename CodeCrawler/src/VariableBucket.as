package  
{
	/**
	 * ...
	 * @author Swifty
	 */
	public class VariableBucket extends Item
	{
		[Embed (source = "../assets/gfx/bucket.png")] private static var sprite:Class;
		
		public var name:String;
		public var value:Constant;
		public var ParameterDoor:Door;
		
		public function VariableBucket(name:String, value:Constant, x:int, y:int) {
			super(x, y);
			loadGraphic(sprite);
			this.name = name;
			this.value = value;
		}
		
		public function isEmpty():Boolean {
			return this.value == null;
		}
		
		public function makeParameter(targetDoor:Door):void {
			ParameterDoor = targetDoor;
		}
		
		override public function getDescription():String {
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
				return new VariableBucket(this.name, (Constant)(value.cloneAt(new_x, new_y)), new_x, new_y);
		}
		
		override public function doAction(player:Player, room:Room):void
		{
			if (ParameterDoor == null)
			{
				player.variable_list.addItem(this);
				this.visible = false;
				room.items.removeItem(this);
			}
			else
			{
				if (player.constant_list.length != 0)
				{
					var TransferedBucket:VariableBucket = (VariableBucket)(this.cloneAt(100, 100));
					TransferedBucket.ParameterDoor = null;
					TransferedBucket.value = (Constant)(player.constant_list.removeItemAt(0));
					ParameterDoor.linked_room = ParameterDoor.linked_room_layout.generateRoom(TransferedBucket.value, room);
					ParameterDoor.linked_room.instantiateTemplateItem(TransferedBucket);
					
					ParameterDoor.doAction(player,room);
				}
			}
			room.items.removeItem(this);
			this.kill();
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