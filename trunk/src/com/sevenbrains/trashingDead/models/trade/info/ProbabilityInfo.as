//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.models.trade.info {
	
	import com.sevenbrains.trashingDead.models.trade.ProbabilityData;
	import com.sevenbrains.trashingDead.models.utils.ISingleInfo;
	
	public class ProbabilityInfo implements ISingleInfo {
		
		public static const INFO_TYPE:String = "probability";
		
		private var _values:Vector.<ProbabilityData>;
		
		public function ProbabilityInfo(values:Vector.<ProbabilityData>) {
			_values = values;
		}
		
		public function toString():String {
			return "[ProbabilityInfo> " + getValuesToString() + "]";
		}
		
		public function get values():Vector.<ProbabilityData> {
			return _values;
		}
		
		private function getValuesToString():String {
			var result:String = new String();
			
			for each (var p:ProbabilityData in _values) {
				result += p.probability + ",";
			}
			return result;
		}
	}
}