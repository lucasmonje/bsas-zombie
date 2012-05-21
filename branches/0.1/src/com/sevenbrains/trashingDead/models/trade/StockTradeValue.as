//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.models.trade {
	
	import com.sevenbrains.trashingDead.models.trade.info.StatsInfo;
	import com.sevenbrains.trashingDead.models.trade.info.StockInfo;
	import com.sevenbrains.trashingDead.models.utils.ISingleInfo;
	
	public class StockTradeValue extends AbstractTradeValue {
				
		protected var _code:int;
		protected var _quantity:int;
		
		public function StockTradeValue(code:int, quantity:int) {
			_code = code;
			_quantity = quantity;
			_type = StatsInfo.INFO_TYPE;
		}
		
		override public function addToTradeValueInfo(info:TradeValueInfo):void {
			info.addStockedItem(_code, _quantity);
		}
		
		override public function canBeModified():Boolean {
			return false;
		}
		
		public function get code():int {
			return _code;
		}
		
		override public function copy():ITradeValue {
			var copy:StockTradeValue = new StockTradeValue(_code, _quantity);
			copy._info = _info.copy();
			return copy;
		}
		
		override public function get possibleModifierEffects():Array {
			return [];
		}
		
		public function get quantity():int {
			return _quantity;
		}
		
		override public function get singleInfos():Vector.<ISingleInfo> {
			var infos:Vector.<ISingleInfo> = new Vector.<ISingleInfo>();
			var info:StockInfo = new StockInfo(_code, quantity);
			infos.push(info);
			infos.fixed = true;
			return infos;
		}
	}
}