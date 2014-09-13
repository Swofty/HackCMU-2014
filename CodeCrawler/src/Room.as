package
{
	import org.flixel.FlxTilemap;
	import mx.collections.ArrayList;
	/**
	 * ...
	 * @author Swifty
	 */
	public class Room extends FlxTilemap
	{
		public var items:ArrayList;
		
		/** String of the function call with arg */
		public var room_title:String; 
		
		/**
		 * Creates a room modeling after a function call with argument arg.
		 * TODO: Add EntryDoor into the function room
		 * TODO: Add VariableBucket for the arg next to the door
		 * TODO: Create the title
		 * @param	arg
		 * @param	parent
		 */
		public function Room(arg:Constant, parent:Room, function_name:String)
		{
			this.items = new ArrayList();
			this.room_title = function_name + "(" + arg + ")";
			
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
		
		public function findFreeY(item:Item):int {
			return (int)(Math.random() * this.heightInTiles) * this._tileWidth;
		}
	}

}