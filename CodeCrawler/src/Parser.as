package  
{
	import flash.utils.Dictionary;
	import mx.collections.ArrayList;
	/**
	 * ...
	 * @author Swifty
	 */
	public class Parser 
	{
		public var data:String;
		public var gd:GameData;
		public var numArgsDict:Dictionary;
		public var functionMap:Dictionary;
		
		public function Parser() 
		{
			arrayInit();
			
			// Define the path to the text file.
			var url:URLRequest = new URLRequest("file.txt");

			// Define the URLLoader.
			var loader:URLLoader = new URLLoader();
			loader.load(url);

			// Listen for when the file has finished loading.
			loader.addEventListener(Event.COMPLETE, loaderComplete);
		}
		
		public function arrayInit():void {
			numArgsDict = new Dictionary();
			numArgsDict["return"] = 1;
			numArgsDict["call"] = 2;
			numArgsDict["add"] = 2;
			numArgsDict["sub"] = 2;
			numArgsDict["mul"] = 2;
			numArgsDict["div"] = 2;
			numArgsDict["eq"] = 2;
			numArgsDict["gt"] = 2;
			numArgsDict["lt"] = 2;
			numArgsDict["ge"] = 2;
			numArgsDict["le"] = 2;
			numArgsDict["call"] = 1;
			
			functionMap = new Dictionary();
			functionMap["return"] =
				function (values:Array) {};
		}
		
		public function loaderComplete(e:Event):void
		{
			// The output of the text file is available via the data property
			// of URLLoader.
			this.data = loader.data;
			gd = new GameData();
			gd.room_layout_list = new ArrayList();
			gd.main_room_layout = new RoomLayout("main");
		}
		
		public function parse(stream:String) {
			while(stream.length > 0) {
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
				else { // main function?
					parseExpression(gd.main_room_layout.template_items, tokens, 0);
				}
			}
		}
		
		public function parseCondition(stream:String) : void {			
			var first_chest:ConditionChest = null;
			var curr_chest:ConditionChest = null;
			var item_list:ArrayList = null;
			while (stream.length > 0) {
				var split:String = stream.split("\n", 2);
				var line:String = split[0] as String;
				var remain:String = split[1] as String;
				var tokens:String = line.split(" ");
				if (tokens[0] == "if" || tokens[0] == "elif" || tokens[0] == "else") {
					var func:Operation;
					if (tokens[1] == "eq") {
							func = new Operation(tokens[1], 0, 0);
							func.setLeftInput(null);
							func.setRightInput(new Constant("int", parseInt(tokens[3]), 0, 0));
					}
					else {
						func = new Operation("eq", 0, 0);
						func.setLeftInput(null);
						func.setRightInput(new Constant("int", parseInt(tokens[3]), 0, 0));
					}
					if (curr_chest == null) {
						first_chest = new ConditionChest(func, 0, 0); 
						curr_chest = first_chest;
						item_list = curr_chest.true_results;
					}
					else {
						if (tokens[0] == "elif") {
							var new_chest:ConditionChest = new ConditionChest(func, 0, 0);
							curr_chest.false_results.addItem = new_chest;
							curr_chest = new_chest;
							item_list = new_chest.true_results;
						}
						else {
							item_list = curr_chest.false_results;
						}
					}
					stream = remain;
				}
				else if (tokens[0] == "start" && tokens[1] == "condition") {
					var end_index:int = remain.indexOf("end condition\n");
					var chest:ConditionChest = parseCondition(remain.substring(0, end_index));
					item_list.addItem(chest);
					stream = remain.substring(end_index + "end condition\n".length);
				}
				else if (tokens[0] == "return") {
					var expList:ArrayList = new ArrayList(tokens);
					parseExpression(item_list, expList, 0);
					stream = remain;
				}
			}
			return first_chest;
		}
		
		public function parseItems(stream:String) : ArrayList {
			var items:ArrayList = new ArrayList();
		}
		
		/**
		 * TODO
		 * Creates a room layout. Instaniates non-visible objects that represent template items
		 * to create a blueprint for the room
		 * */
		public function parseRoomLayout(name:String, stream:String) : void {
			trace("Constructing RoomLayout for function" + name);
			var layout:RoomLayout = new RoomLayout(name);
			this.gd.room_layout_list.addItem(layout);
			
			while (stream.length > 0) {
				var split:String = stream.split("\n", 2);
				var line:String = split[0] as String;
				var remain:String = split[1] as String;
				var tokens:String = line.split(" ");
				
				trace ("Current line: " + line);
				if (tokens[0] == "parameter") {
					layout.addParam(tokens[1]);
					stream = remain;
				}
				else if (tokens[0] == "start" && tokens[1] == "condition") {
					var end_index:int = remain.indexOf("end condition\n");
					var chest:ConditionChest = parseCondition(remain.substring(0, end_index));
					layout.addTemplateItem(chest);
					stream = remain.substring(end_index + "end condition\n".length);
				}
				else if (tokens[0] == "return") {
					var expList:ArrayList = new ArrayList(tokens);
					parseExpression(layout.template_items, expList, 0);
					stream = remain;
				}
			}
			return layout;
		}
		
		public function parseExpression(item_list:ArrayList, args:ArrayList, i:int) : Item
		{
			//return add call fib 1 sub var x const 1 call fib 1 sub var x const 2
			term = args.getItemAt(i);
			if(term is String && term == "const"){
				args.setItemAt(i) = args.getItemAt(i + 1);
				args.removeItemAt(i + 1);
				return Constant("int", parseInt(args.getItemAt(i)), 0, 0);
			}
			else if(term is String && term == "var"){
				args.setItemAt(args.getItemAt(i + 1), i);
				args.removeItemAt(i + 1);
				return VariableBucket(args.getItemAt(i), null, 0, 0);
			}
			else if (term is String && term == "call") {
				var numParams:int = args.getItemAt(i + 2);
				args.removeItemAt(i + 2);
				for (var j:int = 0; j < numArgs; j++) {
					parseExpression(args, i + j + 2);
				}
				var room_layout:RoomLayout = null;
				for (var j:int = 0; j < gd.room_layout_list.length; j++) {
					if (((RoomLayout) gd.room_layout_list[j]).layout_name == args.getItemAt(i + 1))
						room_layout = (RoomLayout) gd.room_layout_list[j];
				}
				
				item_list.addItem(new Door(room_layout, 0, 0));
				var v:Item = VariableBucket(args.getItemAt(i + 1), null, 0, 0);
				
				args.removeItemAt(i + 1)
				args.setItemAt(v, i);
				for (var j:int; j < numArgs; j++) {
					args.removeItemAt(j + 1);
				} //removes arguments
				return v;
			}
			else {
				trace("parseExpression else case -- term: " + term);
				numArgs = this.numArgsDict[term];
				var values:Array = new Array();
				for(var j:int = 0; j<numArgs; j++){
					values.push(this.parseExpression(args, i+j+1));
				}
				var v:Item = item_list.addItem(new Operation(term, 0, 0));
				args.setItemAt(v, i);
				for (var j:int; j < numArgs; j++) {
					args.removeItemAt(j + 1);
				} //removes arguments
				return v;
			}
		}
	}

}