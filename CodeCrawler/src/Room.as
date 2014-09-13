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
		
		// Constants that refer tot he room's walls
		public static var TOP:int = 0;
		public static var RIGHT:int = 1;
		public static var BOTTOM:int = 2;
		public static var LEFT:int = 3;
		
		/** String of the function call with arg */
		public var room_title:String; 
		
		/** Room that return door will lead back to */
		public var parent_room:Room;
		
		/**
		 * An ArrayList of references to the doors within this room.
		 * I assume the OverworldState will need this to help detect interaction
		 * between the player and the doors
		 */
		public var doors:ArrayList;
		
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
			this.items.addItem(arg);
			
			this.room_title = function_name + "(" + arg + ")";
			this.parent_room = parent;
			
			// Adds door for entrance
			// this.addItem(new EntryDoor(parent, x, y));
			
			// Adds bucket by the door with argument
			// this.addItem(new VariableBucket(arg, x, y));
		}
		
		/**
		 * Takes a template item (an item with no real x, y coordinate and is invisible)
		 * and instantiates a real instance of that item with a valid x and y coordinate
		 * within the room.
		 * @param	template_item
		 */
		public function instantiateTemplateItem(template_item:Item):void {
			if (template_item is Door) {
				var template_door:Door = template_item as Door;
				if (template_door.door_type == Door.FUNCTION) {
					createFunctionDoorSet(template_door);
				}
			}
			else {
				var spawn_x:int = this.findFreeX(template_item);
				var spawn_y:int = this.findFreeY(template_item);
				var real_item:Item = template_item.cloneAt(spawn_x, spawn_y);
				items.addItem(real_item);
			}
		}
		
		/**
		 * Takes a template door that represents a function call and instantiates the set of Items
		 * that are necessary to make the door function. A function call door
		 * needs to have empty VariableBuckets associated with it, and needs to have
		 * its associated_parent specified to be the current Room.
		 * @param	template_door the template function door to create and instance of
		 */
		private function createFunctionDoorSet(template_door:Door):void {
			var door_x:int = 0; // TODO
			var door_y:int = 0; // TODO
			var wall:int = TOP; // TODO
			
			var layout:RoomLayout = template_door.linked_room_layout;
			
			var real_door:Door = new Door(layout, door_x, door_y);
			
			var bucket_offset_x:int = 0;
			var bucket_offset_y:int = 0;
			if (wall == TOP) {
				bucket_offset_x = this._tileWidth;
				bucket_offset_y = 0;
			}
			else if (wall == RIGHT) {
				bucket_offset_x = 0;
				bucket_offset_y = this._tileHeight;
			}
			else if (wall == BOTTOM) {
				bucket_offset_x = -1 * this._tileWidth;
				bucket_offset_y = 0;
			}
			else if (wall == LEFT) {
				bucket_offset_x = 0;
				bucket_offset_y = -1 * this._tileHeight;
			}
			
			var buckets:ArrayList = new ArrayList();
			for (var i:int = 0; i < layout.param_names.length; i++)
			{
				var bucket_x:int = bucket_offset_x * (i + 1);
				var bucket_y:int = bucket_offset_y * (i + 1);
				var bucket:VariableBucket = new VariableBucket((String)(layout.param_names.getItemAt(i)), null, bucket_x, bucket_y);
				items.addItem(bucket);
				buckets.addItem(bucket);
			}
			
			real_door.setFunctionCallVariables(this, wall, buckets);
			items.addItem(real_door);
			doors.addItem(real_door);
		}
		
		public function findFreeX(item:Item):int {
			return int(Math.random() * this.widthInTiles) * this._tileWidth;
		}
		
		public function findFreeY(item:Item):int {
			return (int)(Math.random() * this.heightInTiles) * this._tileWidth;
		}
	}

}