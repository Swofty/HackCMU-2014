package 
{
	import org.flixel.FlxSprite;
	
	/**
	 * Abstract Item class. Itended to not have a Graphic.
	 * @author Swifty
	 */
	public class Item extends FlxSprite
	{
		public function Item(x:int, y:int) {
			super(x, y);
		}
		
		/**
		 * Returns the String description to be displayed in the "Op Box."
		 * @return the String description to be displayed
		 */
		public function getDescription() : String {
			return "Generic item";
		}
		
		public function cloneAt(new_x:int, new_y:int) : Item {
			return new Item(new_x, new_y);
		}
		
		public function toString():String {
			return "Generic item";
		}
	}
	
}