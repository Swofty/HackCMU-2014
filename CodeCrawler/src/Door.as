package  
{
	import org.flixel.*;

	public class Door extends FlxSprite 
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
		
		public function Door(X:int,Y:int) 
		{
			super(X, Y);
		}
	}
}