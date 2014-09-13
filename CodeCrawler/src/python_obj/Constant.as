package 
{
	
	/**
	 * ...
	 * @author Swifty
	 */
	public class Constant extends Item
	{
		[Embed(source = "../assets/gfx/Bitman.png")] private static var sprite:Class;
		public var type:String;
		public var value;
		
		public function Constant(type, value, x, y) {
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
	}
	
}