package  
{
	import mx.collections.ArrayList;
	/**
	 * ...
	 * @author Swifty
	 */
	public class Parser 
	{
		var data:String;
		
		public function Parser() 
		{
			// Define the path to the text file.
			var url:URLRequest = new URLRequest("file.txt");

			// Define the URLLoader.
			var loader:URLLoader = new URLLoader();
			loader.load(url);

			// Listen for when the file has finished loading.
			loader.addEventListener(Event.COMPLETE, loaderComplete);
		}
		
		public function loaderComplete(e:Event):void
		{
			// The output of the text file is available via the data property
			// of URLLoader.
			this.data = loader.data;
		}
		
		public function parse( data:String) {
			var gd:GameData = new GameData();
			gd.room_layout_list = new ArrayList();
			gd.main_room = new Room(new Constant("int", 0, 0, 0), null, "main");
			
			var split:Array = data.split("\n", 2);
			var line:String = split[0] as String;
			var remain:String = split[1] as String;
			var tokens:String = line.split(" ");
			if (tokens[0] == "start") {
				if (tokens[1] == "room") {
					var name = tokens[2];
					var startIndex:int = 0;
					var endIndex:int = remain.indexOf("end room");
					var roomLayoutData = remain.substring(startIndex, endIndex);
					gd.room_layout_list.addItem(RoomLayout.parseRoomLayout(name, remain));
					return parse(remain.substring(endIndex + "end room".length + 1));
				}
			}
		}
	}

}