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
	
	public class StatsInfo implements ISingleInfo {
		
		public static const INFO_TYPE:String = "stats";
		
		private var _name:String;
		private var _quantity:int;
		
		public function StatsInfo(name:String, quantity:int) {
			_name = name;
			_quantity = quantity;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get quantity():int {
			return _quantity;
		}
		
		public function toString():String {
			return "[StatsInfo> " + "name:" + _name + "quantity:" + _quantity + "]";
		}
	}
}