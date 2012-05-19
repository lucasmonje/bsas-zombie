package com.sevenbrains.trashingDead.processor
{
	import flash.utils.Dictionary;
	
	public function get PROCESSORS():Dictionary {
		var processorsMap:Dictionary = new Dictionary(true);
		processorsMap[MultipleInfo.INFO_TYPE] = MultipleTradeValueProcessor.instance;
		processorsMap[ProbabilityInfo.INFO_TYPE] = ProbabilityRewardProcessor.instance;
		processorsMap[StatsInfo.INFO_TYPE] = StatsTradeValueProcessor.instance;
		processorsMap[StockInfo.INFO_TYPE] = StockTradeValueProcessor.instance;
		return processorsMap;
	}
}