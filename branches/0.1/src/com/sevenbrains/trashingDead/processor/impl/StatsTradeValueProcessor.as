//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.processor.impl {
	
	import com.sevenbrains.trashingDead.exception.InvalidArgumentException;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.models.trade.ITradeValue;
	import com.sevenbrains.trashingDead.models.trade.StatsTradeValue;
	import com.sevenbrains.trashingDead.models.utils.IOperationContext;
	import com.sevenbrains.trashingDead.processor.ITradeValueProcessor;
	
	public class StatsTradeValueProcessor implements ITradeValueProcessor {
		
		public function StatsTradeValueProcessor() {
		}
		
		public function canProcess(value:ITradeValue, quantity:int = 1, context:IOperationContext = null):Boolean {
			var statsTradeValue:StatsTradeValue = StatsTradeValue(value);
			
			if (!statsTradeValue) {
				throw new InvalidArgumentException("StatsTradeValueProcessor expects a StatsTradeValue");
			}
			return UserModel.instance.stats.canSubstract(statsTradeValue.stats, quantity);
		}
		
		public function preProcessCost(value:ITradeValue, context:IOperationContext = null, preprocess:Boolean = false):Vector.<ITradeValue> {
			return Vector.<ITradeValue>([value]);
		}
		
		public function preProcessReward(value:ITradeValue, context:IOperationContext = null, preprocess:Boolean = false):Vector.<ITradeValue> {
			return Vector.<ITradeValue>([value]);
		}
		
		public function processCost(value:ITradeValue, context:IOperationContext = null):Vector.<ITradeValue> {
			var statsTradeValue:StatsTradeValue = StatsTradeValue(value);
			
			if (!statsTradeValue) {
				throw new InvalidArgumentException("StatsTradeValueProcessor expects a StatsTradeValue");
			}
			
			UserModel.instance.stats.subtract(statsTradeValue.stats);
			
			return Vector.<ITradeValue>([statsTradeValue]);
		}
		
		public function processReward(value:ITradeValue, context:IOperationContext = null):Vector.<ITradeValue> {
			var statsTradeValue:StatsTradeValue = StatsTradeValue(value);
			
			if (!statsTradeValue) {
				throw new InvalidArgumentException("StatsTradeValueProcessor expects a StatsTradeValue");
			}
			
			UserModel.instance.stats.add(statsTradeValue.stats);
			return Vector.<ITradeValue>([statsTradeValue]);
		}
	}
}