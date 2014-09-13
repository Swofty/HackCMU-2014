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
		var gd:GameData;
		
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
			gd = new GameData();
			gd.room_layout_list = new ArrayList();
			gd.main_room = new Room(new Constant("int", 0, 0, 0), null, "main");
		}
		
		public function parse(data:String) {
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
					gd.room_layout_list.addItem(parseRoomLayout(name, remain));
					return parse(remain.substring(endIndex + "end room".length + 1));
				}
			}
		}
		
		/**
		 * TODO
		 * Creates a room layout. Instaniates non-visible objects that represent template items
		 * to create a blueprint for the room
		 * */
		public static function parseRoomLayout(name:String, stream:String) : void {
			var layout:RoomLayout = new RoomLayout(name);
			this.gd.room_layout_list.addItem(layout);
			
			while (stream.length > 0) {
				var split:String = stream.split("\n", 2);
				var line:String = split[0] as String;
				var remain:String = split[1] as String;
				var tokens:String = line.split(" ");
				
				if (tokens[0] == "parameter") {
					layout.addParam(tokens[1]);
					stream = remain;
				}
				else if (tokens[0] == "start" && tokens[1] == "condition") {
					var end_index:int = remain.indexOf("end condition\n");
					var chest:ConditionChest = ConditionChest.parseConditionChest(remain.substring(0, end_index));
					layout.addTemplateItem(chest);
					stream = remain.substring(end_index + "end condition\n".length);
				}
				else if (tokens[0] == "return") {
					var expList:ArrayList = new ArrayList(tokens);
					parseExpression(takens, 0);
				}
			}
			return new RoomLayout("Garbage");
		}
		
		public function parseExpression(args:ArrayList, i:int) : void
		{
			//return add call fib 1 sub var x const 1 call fib 1 sub var x const 2
			term = args.getItemAt(i);
			if(term is String && term == "const"){
				args.setItemAt(i) = args.getItemAt(i + 1);
				args.removeItemAt(i + 1);
				return args[i];
			}
			else if(term == "var"){
				//Do thing regarding vars here
				args[i] = args[i+1];
				args.removeItemAt(i+1);
				return args[i];
			}
			numArgs = this.numArgsDict[term];
			var values:Array = new Array();
			for(var i:int; i<numArgs; i++){
				values.push(this.parse(args, i+i));
			}
			var v:String = functionMap[term](values);
			args[i] = v;
			for(var i:int; i<numArgs; i++){ args.removeItemAt(i+1); } //removes arguments
			return v;
		}
	}

}