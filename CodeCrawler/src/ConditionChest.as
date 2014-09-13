package 
{
	import mx.collections.ArrayList;
	/**
	 * ...
	 * @author Swifty
	 */
	public class ConditionChest extends Item 
	{
		[Embed(source = "../assets/gfx/closedChest.png")] private static var closedChest:Class;
		[Embed(source = "../assets/gfx/openChest.png")] private static var openChest:Class;
		public var operator:Operation;	//operators are anonomyous functions that ask for 2 constants, 1 constant, 2 variables, or 1 variable?
		public var true_results:ArrayList; //This is an ArrayList of items
		public var false_results:ArrayList; //This is an ArrayList of items

		
		public function ConditionChest(operator:Function, x:int, y:int) {
			super(x, y);
			loadGraphic(closedChest);
			this.operator = operator;
			this.true_results = new ArrayList();
			this.false_results = new ArrayList();
		}
		
		override public function getDescription():String {
			return "Value: " + value;
		}
		
		override public function cloneAt(x:int, y:int):Item {
			return new ConditionChest(this.operator, this.true_results, this.false_results, x, y);
		}
		
		override public function doAction(player:Player, room:Room):void
		{
			player.constant_list.addItem(this);
			this.visible = false;
			room.items.removeItem(this);
			this.kill();
		}
		
		override public function toString():String {
			return "Value: " + value;
		}
	}
	
}