//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.condition {
	
	import com.sevenbrains.trashingDead.condition.ItemConditionDefinition;
	import com.sevenbrains.trashingDead.condition.core.ConditionDefinition;
	import com.sevenbrains.trashingDead.condition.core.IConditionChecker;
	import com.sevenbrains.trashingDead.exception.InvalidArgumentException;
	
	public class ItemConditionChecker implements IConditionChecker {
		
		public function ItemConditionChecker() {
		}
		
		public function checkCondition(condition:ConditionDefinition):Boolean {
			var itemCondition:ItemConditionDefinition = getTypedCondition(condition);
			//TODO: LOCK MANAGER
			return true;
		}
		
		public function getFulfilledConditions(condition:ConditionDefinition):Array {
			var itemCondition:ItemConditionDefinition = getTypedCondition(condition);
			//TODO: LOCK MANAGER
			return [];
		}
		
		public function getMissingConditions(condition:ConditionDefinition):Array {
			var itemCondition:ItemConditionDefinition = getTypedCondition(condition);
			//TODO: LOCK MANAGER
			return [];
		}
		
		protected function getTypedCondition(condition:ConditionDefinition):ItemConditionDefinition {
			var itemCondition:ItemConditionDefinition = ItemConditionDefinition(condition);
			
			if (!itemCondition) {
				throw new InvalidArgumentException("ItemConditionChecker expects a condition of type ItemConditionDefinition");
			}
			return itemCondition;
		}
	}
}