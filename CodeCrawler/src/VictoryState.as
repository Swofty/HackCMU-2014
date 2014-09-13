package  
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import flash.text.*;
	import flash.events.Event;
	import com.greensock.*;
	/**
	 * ...
	 * @author rojerplz
	 */
	
	public class VictoryState extends FlxState
	{
		FlxG.debug;
		public var final_output:FlxText;
		private var RestartButton:FlxButton = new FlxButton(500, 500, "Restart", restartGame);
		
		public function VictoryState(final_output:String)
		{
			this.final_output = new FlxText(300, 300, 700, "Congratulations! Your final output is " + final_output);
			this.final_output.size *= 5;
		}
		
		override public function create():void
		{
			add(final_output);
			add(RestartButton);
		}
		
		private function restartGame():void {
			FlxG.resetGame();
		}
	}
}