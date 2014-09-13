package 
{
	import flash.display.InterpolationMethod;
	import flash.utils.*; //added
	import mx.formatters.StringFormatter;
	
	/**
	 * ...
	 * @author Mountain Dew
	 */
	public class Operation extends Item 
	{
		public var left_arg:Constant;
		public var left_label:String;
		public var right_arg:Constant;
		public var right_label:String;
		public var op:String;
		public var applied_fun:Function;
		public var return_item:Constant;
		
		public function Operation(operation:String, x:int, y:int)
		{
			super(x, y);
			this.op = operation;
			this.return_item = null;
		}
		
		public function setLeftInput(left:Constant, label:String) {
			left_arg = left;
			left_label = label;
		}
		
		public function setRightInput(right:Constant, label:String) {
			right_arg = right;
			right_label = label;
		}
		
		public function generateReturn():void {
			if (left_arg == null || right_arg == null)
				return;
			
			if (op == "eq") {
				if (left_arg.value == right_arg.value)
					return_item = new Constant("int", 1, 0, 0);
				else
					return_item = new Constant("int", 1, 0, 0);
			}
			else if (op == "add") {
				return_item = new Constant("int", left_arg.value + right_arg.value, 0, 0);
			}
			else if (op == "sub") {
				return_item = new Constant("int", left_arg.value - right_arg.value, 0, 0);
			}
				
		}
		
	}
	
}