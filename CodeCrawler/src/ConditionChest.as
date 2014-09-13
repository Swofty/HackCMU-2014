package 
{
	import mx.collections.ArrayList;
	/**
	 * ...
	 * @author Swifty
	 */
	public class ConditionChest extends Item 
	{
		[Embed(source = "../assets/gfx/closedChest.png")] private static var closedChest:Class;
		[Embed(source = "../assets/gfx/openChest.png")] private static var openChest:Class;
		public var operator:Operation;	//operators are anonomyous functions that ask for 2 constants, 1 constant, 2 variables, or 1 variable?
		public var true_results:ArrayList; //This is an ArrayList of items
		public var false_results:ArrayList; //This is an ArrayList of items

		
		public function ConditionChest(operator:Operation, x:int, y:int) {
			super(x, y);
			loadGraphic(closedChest);
			this.operator = operator;
			this.true_results = new ArrayList();
			this.false_results = new ArrayList();
		}
		
		override public function cloneAt(x:int, y:int):Item {
			var result:ConditionChest = new ConditionChest(this.operator, x, y);
			var copy_true_results:ArrayList = new ArrayList();
			var copy_false_results:ArrayList = new ArrayList();
			for (var i:int = 0; i < true_results.length; i++) {
				copy_true_results.setItemAt((Item)(true_results.getItemAt(i)).cloneAt(x, y), i);
			}
			for (var i:int = 0; i < false_results.length; i++) {
				copy_false_results.setItemAt((Item)(false_results.getItemAt(i)).cloneAt(x, y), i);
			}
			result.true_results = copy_true_results;
			result.false_results = copy_false_results;
			return result;
		}
		/*
		override public function doAction(player:Player, room:Room):void
		{
			var restore_variable_list:ArrayList = player.variable_list
			var restore_constant_list:ArrayList = player.constant_list
						
			var truth_value:Boolean;
			if (this.operator.arg1_type == "Variable" && this.operator.arg2_type == "Variable")
				truth_value = this.operator.applied_fun(player.variable_list.removeItemAt(0), player.variable_list.removeItemAt(0));
			else if (this.operator.arg1_type == "Variable" && this.operator.arg2_type == "Constant")
				truth_value = this.operator.applied_fun(player.variable_list.removeItemAt(0), player.constant_list.removeItemAt(0));
			else if (this.operator.arg1_type == "Constant" && this.operator.arg2_type == "Variable")
				truth_value = this.operator.applied_fun(player.variable_list.removeItemAt(0), player.constant_list.removeItemAt(0));
			else if (this.operator.arg1_type == "Constant" && this.operator.arg2_type == "Constant")
				truth_value = this.operator.applied_fun(player.variable_list.removeItemAt(0), player.constant_list.removeItemAt(0));

			else if (this.operator.arg1_type == "Variable" && this.operator.arg2_type == "Prebaked")
				truth_value = this.operator.applied_fun(player.variable_list.removeItemAt(0));
			else if (this.operator.arg1_type == "Constand" && this.operator.arg2_type == "Prebaked")
				truth_value = this.operator.applied_fun(player.constant_list.removeItemAt(0));
			else if (this.operator.arg1_type == "Prebaked" && this.operator.arg2_type == "Variable")
				truth_value = this.operator.applied_fun(player.variable_list.removeItemAt(0));
			else if (this.operator.arg1_type == "Prebaked" && this.operator.arg2_type == "Constant")
				truth_value = this.operator.applied_fun(player.constant_list.removeItemAt(0));
			else if (this.operator.arg1_type == "Prebaked" && this.operator.arg2_type == "Prebaked")
				truth_value = this.operator.applied_fun();
			else
				truth_value = false;
				
			if (truth_value) {
				for (var i:int = 0; i < this.true_results.length; i++)
					room.instantiateTemplateItem((Item)(this.true_results.getItemAt(i)));
			}
			else {
				player.constant_list = restore_constant_list;
				player.variable_list = restore_variable_list;
				for (var i:int = 0; i < this.false_results.length; i++)
					room.instantiateTemplateItem((Item)(this.false_results.getItemAt(i)));
			}
			this.kill();
		}
		
		override public function toString():String {
			return "Value: " + value;
		}
		*/
	}
	
}