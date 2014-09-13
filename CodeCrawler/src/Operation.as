package 
{
	import flash.display.InterpolationMethod;
	import flash.utils; //added
	
	/**
	 * ...
	 * @author Mountain Dew
	 */
	public class Operation extends Item 
	{
		public var arg1_type:String;
		public var arg2_type:String;
		public var applied_fun:Function;
		public var return_item:Item;
		public var numArgsDict:Dictionary;
		public var functionMap:Dictionary;
		
		public function Operation(operation:String)
		{
			//we get the binary operator
			/*
			binary_operator:String;
			arg1:String;
			arg2:String;
			*/
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
			
			functionMap = new Dictionary;
			functionMap["return"] = this.ret;
			functionMap["call"] = this.cal;
			//the following should probably be redefined

			
			var args:Array;
			args = operation.split(" ");
			
			this.parse(args, 0);
			/*
			if (operation.indexOf(" ") != -1)
			{
				binary_operator = operation.substring(0, operation.indexOf(" "));
				operation = operation.substring(operation.indexOf(" ")+1);
			}
			else
			{
				binary_operator:String = operation.substring(0, operation.indexOf("\n"));
			}

			//we get the 1st argument type
			if (operation.indexOf(" ") != -1)
			{
				arg1 = operation.substring(0, operation.indexOf(" "));
				operation = operation.substring(operation.indexOf(" ")+1);
			}
			else
			{
				arg1 = operation.substring(0, operation.indexOf("\n"));
			}
			
			if (operation.indexOf(" ") != -1)
			{
				arg2 = operation.substring(0, operation.indexOf(" "));
				operation = operation.substring(operation.indexOf(" ")+1);
			}
			else
			{
				arg2 = operation.substring(0, operation.indexOf("\n"));
			}
			
			switch(binary_operator) {
				case "+" :
					if (arg1_type == "" && arg2_type == "") {
						arg1_type = "Constant";
						arg2_type = "Constant";
						operation = 
							function(x:Constant, y:Constant) {
								x + y;
							}
					}
					else if (arg2_type == "") {
						arg1_type = "Constant"
						arg2_type = "Constant"
						operation =
							function(x:Constant) {
								x + arg2_cons;
							}
					}
			}*/
				
		}
		public function parse(args:Array, ind:int)
		{
			//return add call fib 1 sub var x const 1 call fib 1 sub var x const 2
			term = args[ind];
			if(term == "const"){
				args[ind] = args[ind+1];
				args.removeItemAt(ind+1);
				return args[ind];
			}
			else if(term == "var"){
				//Do thing regarding vars here
				args[ind] = args[ind+1];
				args.removeItemAt(ind+1);
				return args[ind];
			}
			numArgs = this.numArgsDict[term];
			var values:Array = new Array();
			for(var i:int; i<numArgs; i++){
				values.push(this.parse(args, ind+i));
			}
			var v:String = functionMap[term](values);
			args[ind] = v;
			for(var i:int; i<numArgs; i++){ args.removeItemAt(ind+1); } //removes arguments
			return v;
		}
	}
	
}