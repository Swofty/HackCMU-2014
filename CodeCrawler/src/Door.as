package  
{
	import mx.collections.ArrayList;
	import org.flixel.*;

	public class Door extends Item
	{
		//generate placeholder door sprites to use. There is a different sprite for each style of room
		[Embed(source = "../assets/gfx/DownStairs.png")] private static var Placeholder_Sprite1:Class;
		[Embed(source = "../assets/gfx/DownStairs.png")] private static var Placeholder_Sprite2:Class;
		[Embed(source = "../assets/gfx/DownStairs.png")] private static var Placeholder_Sprite3:Class;

		//2 sprites which indicate if a door is opened or closed
		[Embed(source = "../assets/gfx/UpStairs.png")] private static var Entry_Door:Class;
		[Embed(source = "../assets/gfx/UpStairs.png")] private static var Locked_Door:Class;
		[Embed(source = "../assets/gfx/UpStairs.png")] private static var Opened_Door:Class;
				
		//variables to indicate direction of stairs
		public var descend:Boolean //indicates whether the stair is going down a level or up a level
		public var above:Floor; //indicates the top level of that stair
		public var below:Floor; //indicates the bottomw level of that stair
		

		/** FUNCTION doors represent a function call, the linked_room
		 * should be the room that the function call will generates.
		 */
		public static final var FUNCTION:int = 0;
		
		/** RETURN doors represent a return statement, the linked_room
		 * should be the room that the current function call will return to
		 */
		public static final var RETURN:int = 1;
		
		public var door_type:int;
		public var linked_room_layout:RoomLayout;
		public var linked_room:Room;
		public var parent_room:Room;
		public var associated_wall:String;
		public var associated_buckets:ArrayList;
		
		/**
		 * Constructor for a template version of a function call door.
		 * Only mentions what kind of RoomLayout the door will lead to.
		 * x and y arguments are dummies.
		 * @param	linked_layout the RoomLayout that will be used for the room behind the door
		 * @param	x unnecessary
		 * @param	y unnecessary
		 */
		public function Door(linked_layout:RoomLayout, x:int, y:int) 
		{
			super(x, y);
			this.visible = false;
			this.door_type = FUNCTION;
			this.linked_room = null;
			this.parent_room = null;
			this.associated_wall = null;
			this.associated_buckets = null;
		}
		
		/**
		 * Sets the necessary variables for a function_call door with the
		 * correct remaining variables. This is here to help make sure that
		 * you aren't forgetting any variables to set.
		 * @param	parent
		 * @param	wall
		 * @param	buckets
		 */
		public function setFunctionCallVariables(parent:Room, wall:String, buckets:ArrayList):void {
			this.door_type = FUNCTION;
			this.parent_room = parent;
			this.associated_wall = wall;
			this.associated_buckets = buckets;
		}
		
		/** Don't think this ever needs to be used */
		override public function cloneAt(x:int, y:int):Item {
			var new_door:Door = new Door(this.linked_room_layout, x, y);
			new_door.door_type = this.door_type;
			new_door.parent_room = this.parent_room;
			new_door.associated_wall = this.associated_wall;
			new_door.associated_buckets = this.associated_buckets; // Need deep copy???
			return new_door;
		}
		
	}
}