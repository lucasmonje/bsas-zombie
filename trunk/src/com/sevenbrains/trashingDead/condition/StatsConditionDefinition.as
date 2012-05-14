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
	import com.sevenbrains.trashingDead.interfaces.IStats;
	
	public class StatsConditionDefinition extends ConditionDefinition {
		
		public static const INFO_TYPE:String = "stats";
		
		private var _stats:IStats;
		
		public function StatsConditionDefinition() {
			super();
			_checkerId = "statsConditionChecker";
		}
		
		public function get stats():IStats {
			return _stats;
		}
		
		public function set stats(value:IStats):void {
			_stats = value;
		}
	}
}