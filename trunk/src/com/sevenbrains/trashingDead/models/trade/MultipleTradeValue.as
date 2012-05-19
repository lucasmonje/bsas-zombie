//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.models.trade {
	
	import com.sevenbrains.trashingDead.models.trade.info.MultipleInfo;
	import com.sevenbrains.trashingDead.models.utils.ISingleInfo;
	import com.sevenbrains.trashingDead.utils.HashSet;
	
	public class MultipleTradeValue extends AbstractTradeValue {
		
		protected var _values:Vector.<ITradeValue>;
		
		public function MultipleTradeValue(values:Vector.<ITradeValue>) {
			_values = values;
			_type = MultipleInfo.INFO_TYPE;
		}
		
		override public function addToTradeValueInfo(info:TradeValueInfo):void {
			for each (var v:ITradeValue in values) {
				v.addToTradeValueInfo(info);
			}
		}
		
		override public function canBeModified():Boolean {
			return values.some(function(item:ITradeValue, index:int, vector:Vector.<ITradeValue>):Boolean {
				return item.canBeModified();
			});
		}
		
		override public function copy():ITradeValue {
			var vector:Vector.<ITradeValue> = new Vector.<ITradeValue>();
			
			for each (var item:ITradeValue in _values) {
				vector.push(item.copy());
			}
			var copy:MultipleTradeValue = new MultipleTradeValue(vector);
			copy._info = _info.copy();
			return copy;
		}
		
		override public function get possibleModifierEffects():Array {
			var set:ISet = new HashSet();
			
			for each (var tradeValue:ITradeValue in values) {
				set.addAll(tradeValue.possibleModifierEffects);
			}
			return set.toArray();
		}
		
		override public function get singleInfos():Vector.<ISingleInfo> {
			var infos:Vector.<ISingleInfo> = new Vector.<ISingleInfo>();
			
			for each (var value:ITradeValue in _values) {
				infos = infos.concat(value.singleInfos);
			}
			return infos;
		}
		
		public function get values():Vector.<ITradeValue> {
			return _values;
		}
	}
}