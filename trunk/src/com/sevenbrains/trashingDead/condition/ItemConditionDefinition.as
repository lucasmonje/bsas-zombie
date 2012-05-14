//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.condition {
	
	import com.sevenbrains.trashingDead.condition.core.ConditionDefinition;
	
	public class ItemConditionDefinition extends ConditionDefinition {
		
		public static const INFO_TYPE:String = "item";
		
		private var _code:int;
		private var _quantity:int;
		
		public function ItemConditionDefinition() {
			super();
			_checkerId = "itemConditionChecker";
		}
		
		public function get code():int {
			return _code;
		}
		
		public function set code(value:int):void {
			_code = value;
		}
		
		public function get quantity():int {
			return _quantity;
		}
		
		public function set quantity(value:int):void {
			_quantity = value;
		}
	}
}