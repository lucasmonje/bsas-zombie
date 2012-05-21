//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.models.trade {
	import com.sevenbrains.trashingDead.models.trade.info.ProbabilityInfo;
	import com.sevenbrains.trashingDead.models.utils.ISingleInfo;
	
	public class ProbabilityTradeValue extends AbstractTradeValue {
		
		
		protected var _values:Vector.<ProbabilityData>;
		
		public function ProbabilityTradeValue(values:Vector.<ProbabilityData>) {
			_values = values;
			_type = ProbabilityInfo.INFO_TYPE;
		}
		
		override public function canBeModified():Boolean {
			return false;
		}
		
		override public function copy():ITradeValue {
			var data:Vector.<ProbabilityData> = new Vector.<ProbabilityData>();
			
			for each (var item:ProbabilityData in _values) {
				data.push(item.copy());
			}
			var copy:ProbabilityTradeValue = new ProbabilityTradeValue(data);
			copy._info = _info.copy();
			copy._type = _type;
			return copy;
		
		}
		
		override public function get possibleModifierEffects():Array {
			return [];
		}
		
		override public function get singleInfos():Vector.<ISingleInfo> {
			var parts:Vector.<ISingleInfo> = new Vector.<ISingleInfo>();
			parts.fixed = true;
			return parts;
		}
		
		public function get values():Vector.<ProbabilityData> {
			return _values;
		}
	}
}