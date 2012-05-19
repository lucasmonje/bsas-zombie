//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.models.trade.info {
	
	import com.sevenbrains.trashingDead.models.utils.ISingleInfo;
	
	public class MultipleInfo implements ISingleInfo {

		public static const INFO_TYPE:String = 'multiple';

		private var _values:Vector.<ITradeValue>;
		
		public function MultipleInfo(values:Vector.<ITradeValue>) {
			_values = values;
		}
		
		public function toString():String {
			return "[MultipleInfo]";
		}
		
		public function get values():Vector.<ITradeValue> {
			return _values;
		}
	}
}