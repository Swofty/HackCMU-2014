package 
{
	import flash.display.InterpolationMethod;
	
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
		
		public function Operation(operation:String)
		{
			//we get the binary operator
			binary_operator:String;
			arg1:String;
			arg2:String;
			
			
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
			}
				
		}
	}
	
}