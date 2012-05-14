//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.definitions {
	
	import com.sevenbrains.trashingDead.condition.core.ConditionDefinition;
	import com.sevenbrains.trashingDead.utils.ClassUtil;
	import flash.utils.Dictionary;
	
	public class LockDefinition {
		
		private var _conditions:Vector.<ConditionDefinition>;
		private var _conditionsByType:Dictionary;
		
		private var _id:int;
		
		public function LockDefinition() {
			_conditions = new Vector.<ConditionDefinition>();
			_conditionsByType = new Dictionary();
		}
		
		public function addCondition(condition:ConditionDefinition):void {
			_conditions.push(condition);
			_conditionsByType[ClassUtil.getClass(condition)] = condition;
		}
		
		public function get conditions():Vector.<ConditionDefinition> {
			return _conditions;
		}
		
		public function getConditionDefinitionByType(type:Class):ConditionDefinition {
			return _conditionsByType[type];
		}
		
		public function get id():int {
			return _id;
		}
		
		public function set id(value:int):void {
			_id = value;
		}
	}
}