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
	import com.sevenbrains.trashingDead.condition.core.IConditionChecker;
	import com.sevenbrains.trashingDead.exception.InvalidArgumentException;
	import com.sevenbrains.trashingDead.interfaces.IStats;
	import com.sevenbrains.trashingDead.models.user.Stats;
	
	public class StatsConditionChecker implements IConditionChecker {
		
		private var _stats:IStats;
		
		public function StatsConditionChecker() {
		}
		
		public function checkCondition(condition:ConditionDefinition):Boolean {
			var statsCondition:StatsConditionDefinition = getTypedCondition(condition);
			
			return _stats.canSubstract(statsCondition.stats);
		}
		
		public function getFulfilledConditions(condition:ConditionDefinition):Array {
			var statsCondition:StatsConditionDefinition = getTypedCondition(condition);
			return [];
		}
		
		public function getMissingConditions(condition:ConditionDefinition):Array {
			var statsCondition:StatsConditionDefinition = getTypedCondition(condition);
			return [];
		}
		
		protected function createAtomicStats(from:IStats, key:String):IStats {
			var stats:Stats = new Stats();
			stats.set(key, from.get(key));
			return stats;
		}
		
		protected function createPart(key:String, value:int, current:int):Object {
			var part:Object = new Object();
			part.type = StatsConditionDefinition.INFO_TYPE;
			part.id = key;
			part.count = value;
			part.currentCount = current;
			return part;
		}
		
		protected function getTypedCondition(condition:ConditionDefinition):StatsConditionDefinition {
			var statsCondition:StatsConditionDefinition = StatsConditionDefinition(condition);
			
			if (!statsCondition) {
				throw new InvalidArgumentException("StatsConditionChecker expects a condition of type StatsConditionDefinition");
			}
			return statsCondition;
		}
	}
}