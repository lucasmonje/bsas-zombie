//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.models.trade {
	
	import com.sevenbrains.trashingDead.interfaces.IStats;
	import com.sevenbrains.trashingDead.models.user.Stats;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class TradeValueInfo {
		
		protected var _extraData:Object;
		protected var _stats:IStats;
		protected var _statsClass:Class = Stats;
		protected var _stockedItems:Dictionary;
		protected var _unlockIds:Vector.<Number>;
		
		public function TradeValueInfo() {
			_extraData = {};
		}
		
		public function addExtraData(key:*, value:*):void {
			_extraData[key] = value;
		}
		
		public function addStats(stats:IStats):void {
			if (!_stats) {
				_stats = new _statsClass();
			}
			_stats.add(stats);
		}
		
		public function addStockedItem(code:int, quantity:int):void {
			if (!_stockedItems) {
				_stockedItems = new Dictionary();
			}
			
			if (!_stockedItems[code]) {
				_stockedItems[code] = quantity;
			} else {
				_stockedItems[code] += quantity;
			}
		}
		
		public function addTradeValue(value:ITradeValue):void {
			value.addToTradeValueInfo(this);
		}
		
		public function addUnlockId(lockId:Number):void {
			if (!_unlockIds) {
				_unlockIds = new Vector.<Number>();
			}
			_unlockIds.push(lockId);
		}
		
		public function copy():TradeValueInfo {
			var copy:TradeValueInfo = new TradeValueInfo();
			copy._stockedItems = copyDictionary(_stockedItems);
			return copy;
		}
		
		public function getExtraData(key:*):* {
			return _extraData[key];
		}
		
		public function hasStat(name:String):Boolean {
			return _stats && _stats.get(name);
		}
		
		/**
		 * Returns all the stats of this trade value accumulated
		 * @return IStats
		 *
		 */
		public function get stats():IStats {
			return _stats;
		}
		
		/**
		 * Returns a map of [code:int - quantity:int] of the items in this trade value
		 * @return Dictionary
		 */
		public function get stockedItems():Dictionary {
			return _stockedItems;
		}
		
		public function get unlockIds():Vector.<Number> {
			return _unlockIds;
		}
		
		private function copyDictionary(value:Dictionary):Dictionary {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(value);
			copier.position = 0;
			return copier.readObject() as Dictionary;
		}
	}
}