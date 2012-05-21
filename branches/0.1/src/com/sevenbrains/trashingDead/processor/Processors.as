package com.sevenbrains.trashingDead.processor
{
	import com.sevenbrains.trashingDead.models.trade.info.*;
	import com.sevenbrains.trashingDead.processor.impl.*;
	import flash.utils.Dictionary;
	
	public class Processors {
		
		private static var processorsMap:Dictionary;
		
		public static function get map():Dictionary {
			if (Boolean(processorsMap)) return processorsMap;
			processorsMap = new Dictionary(true);
			processorsMap[MultipleInfo.INFO_TYPE] = new MultipleTradeValueProcessor();
			processorsMap[ProbabilityInfo.INFO_TYPE] = new ProbabilityRewardProcessor();
			processorsMap[StatsInfo.INFO_TYPE] = new StatsTradeValueProcessor();
			processorsMap[StockInfo.INFO_TYPE] = new StockTradeValueProcessor();
			return processorsMap;
		}
	}
	
}