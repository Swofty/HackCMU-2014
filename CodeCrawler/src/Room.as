package src {
	import org.flixel.FlxTilemap;
	import mx.collections.ArrayList;
	/**
	 * ...
	 * @author Swifty
	 */
	public class Room extends FlxTilemap
	{
		public var items:ArrayList;
		
		/**
		 * Creates a room modeling after a function call with argument arg
		 * @param	arg
		 * @param	parent
		 */
		public function Room(arg:Item, parent:Room)
		{
			this.items = new ArrayList();
			
			// Adds door for entrance
			// this.addItem(new EntryDoor(parent, x, y))
			
			// Adds bucket by the door with argument
			// this.addItem(new VariableBucket(null, x, y)
		}
		
		public function addItem(item:Item):void {
			items.addItem(item);
		}
		
		public function findFreeX(item:Item):int {
			return int(Math.random() * this.widthInTiles) * this._tileWidth;
		}
		
		public function findFreeY(item:Item):Item {
			return int(Math.random() * this.heightInTiles) * this._tileWidth;
		}
	}

}