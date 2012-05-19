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
	import com.sevenbrains.trashingDead.models.trade.info.StatsInfo;
	import com.sevenbrains.trashingDead.models.utils.ISingleInfo;
	
	public class StatsTradeValue extends AbstractTradeValue {
		protected var _stats:IStats
		
		public function StatsTradeValue(stats:IStats) {
			_stats = stats;
			_type = StatsInfo.INFO_TYPE;
		}
		
		override public function addToTradeValueInfo(info:TradeValueInfo):void {
			info.addStats(_stats);
		}
		
		override public function canBeModified():Boolean {
			return true;
		}
		
		override public function copy():ITradeValue {
			var copy:StatsTradeValue = new StatsTradeValue(_stats.copy());
			copy._info = _info.copy();
			copy._lock = _lock;
			return copy;
		}
		
		override public function get possibleModifierEffects():Array {
			return [StatsModifier];
		}
		
		override public function get singleInfos():Vector.<ISingleInfo> {
			var infos:Vector.<ISingleInfo> = new Vector.<ISingleInfo>();
			
			for (var name:String in _stats.statsValues) {
				var info:StatsInfo = new StatsInfo(name, _stats.statsValues[name]);
				infos.push(info);
			}
			infos.fixed = true;
			return infos;
		}
		
		public function get stats():IStats {
			return _stats;
		}
	}
}