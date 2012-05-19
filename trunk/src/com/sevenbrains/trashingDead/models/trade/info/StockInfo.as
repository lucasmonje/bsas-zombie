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
	
	public class StockInfo implements ISingleInfo {
		
		public static const INFO_TYPE:String = "stock";
		
		private var _code:int;
		private var _quantity:int;
		
		public function StockInfo(code:int, quantity:int) {
			_code = code;
			_quantity = quantity;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get quantity():int {
			return _quantity;
		}
		
		public function toString():String {
			return "[StockInfo> " + "code:" + _code + "quantity:" + _quantity + "]";
		}
	}
}