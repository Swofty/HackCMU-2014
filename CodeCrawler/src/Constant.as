package
{
	
	/**
	 * ...
	 * @author Swifty
	 */
	public class Constant extends Item
	{
		[Embed(source = "../assets/gfx/coin.png")] private static var sprite:Class;
		public var type:String;
		public var value;
		
		public function Constant(type:String, value, x:int, y:int) {
			super(x, y);
			loadGraphic(sprite);
			this.type = type;
			this.value = value;
		}
		
		override public function getDescription():String {
			return "Value: " + value;
		}
		
		override public function cloneAt(x:int, y:int):Item {
			return new Constant(this.type, this.value, x, y);
		}
		
		override public function doAction(player:Player, room:Room):void
		{
			player.constant_list.addItem(this);
			this.visible = false;
			room.items.removeItem(this);
			this.kill();
		}
		
		override public function toString():String {
			var value_string:String;
			if (type == "string") 
			{
				value_string = "\"" + this.value + "\"";
			}
			else 
			{
				value_string = this.value;
			}
			return value_string + " : " + this.type;
		}
	}
	
}