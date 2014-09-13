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
		public var param_names:ArrayList;
		
		public function RoomLayout(function_name:String) {
			template_items = new ArrayList();
			layout_name = function_name;
			
			param_names = new ArrayList();
		}
		
		public function addParam(param_name:String):void{
			param_names.addItem(param_name);
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
		public function generateRoom(arg:Constant, parent:Room) : Room {
			var room:Room = new Room(arg, parent, this.layout_name);
			for (var i:int = 0; i < template_items.length; i++) {
				var template_item:Item = (Item)(template_items.getItemAt(i));
				room.instantiateTemplateItem(template_item);
			}
			return room;
		}
		
		
	}
	
}