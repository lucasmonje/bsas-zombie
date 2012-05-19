package com.sevenbrains.trashingDead.processor
{
	import com.sevenbrains.trashingDead.models.trade.info.MultipleInfo;
	import com.sevenbrains.trashingDead.models.trade.info.ProbabilityInfo;
	import com.sevenbrains.trashingDead.models.trade.info.StatsInfo;
	import com.sevenbrains.trashingDead.models.trade.info.StockInfo;
	import com.sevenbrains.trashingDead.processor.impl.MultipleTradeValueProcessor;
	import com.sevenbrains.trashingDead.processor.impl.ProbabilityRewardProcessor;
	import com.sevenbrains.trashingDead.processor.impl.StatsTradeValueProcessor;
	import com.sevenbrains.trashingDead.processor.impl.StockTradeValueProcessor;
	
	import flash.utils.Dictionary;
	
	public class Processors {
		
		private static var processorsMap:Dictionary;
		
		public static function get map():Dictionary {
			if (Boolean(processorsMap)) return processorsMap;
			processorsMap = new Dictionary(true);
			processorsMap[MultipleInfo.INFO_TYPE] = MultipleTradeValueProcessor.instance;
			processorsMap[ProbabilityInfo.INFO_TYPE] = ProbabilityRewardProcessor.instance;
			processorsMap[StatsInfo.INFO_TYPE] = StatsTradeValueProcessor.instance;
			processorsMap[StockInfo.INFO_TYPE] = StockTradeValueProcessor.instance;
			return processorsMap;
		}
	}
	
}