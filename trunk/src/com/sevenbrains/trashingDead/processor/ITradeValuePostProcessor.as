//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.processor {
	
	import com.sevenbrains.trashingDead.models.trade.ITradeValue;
	import com.sevenbrains.trashingDead.models.trade.TradeValueInfo;
	import com.sevenbrains.trashingDead.models.utils.IOperationContext;
	
	public interface ITradeValuePostProcessor {
		function process(value:ITradeValue, tradeValueInfo:TradeValueInfo, operation:int, context:IOperationContext = null):void;
	}
}