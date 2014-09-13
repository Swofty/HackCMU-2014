package 
{
	
	import mx.collections.ArrayList;
	import Math;
	/**
	 * A RoomLayout is analagous to a Class.
	 * It outlines what items must be instantiated when
	 * a Room following this RoomLayout is created.
	 * @author Swifty
	 */
	public class RoomLayout
	{
		public var template_items:ArrayList;
		public var layout_name:String;
		
		public function RoomLayout(function_name:String) {
			template_items = new ArrayList();
			layout_name = function_name;
		}
		
		/**
		 * Treats the parameter item as a template item that will
		 * be instantiated (cloned) when the RoomLayout is instantiated.
		 * @param	the item be treated as a template item
		 */
		public function addTemplateItem(template_item:Item) : void {
			template_item.visible = false;
			template_items.addItem(template_item);
		}
		
		/**
		 * Returns an instantiated object of this RoomLayout.
		 * Location of instantiated items in the room will be left to
		 * a function in Room to determin.
		 */
		public function generateRoom() : Room {
			var room:Room = new Room();
			for (var i:int = 0; i < template_items.length; i++) {
				var template_item:Item = template_items[i];
				var spawn_x:int = room.findFreeX(template_item);
				var spawn_y:int = room.findFreeY(template_item);
				var real_item:Item = template_item.cloneAt(spawn_x, spawn_y);
				room.addItem(real_item);
			}
			return room;
		}
		
		/**
		 * TODO
		 * Creates a room layout. Instaniates non-visible objects
		 * to serve as a template for the room.
		 * */
		public static function parseRoomLayout(stream:String) : RoomLayout {
			return new RoomLayout("Garbage");
		}
	}
	
}