//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.processor.impl {
	
	import com.sevenbrains.trashingDead.exception.PrivateConstructorException;
	import com.sevenbrains.trashingDead.models.trade.ITradeValue;
	import com.sevenbrains.trashingDead.models.trade.MultipleTradeValue;
	import com.sevenbrains.trashingDead.models.trade.info.MultipleInfo;
	import com.sevenbrains.trashingDead.models.trade.info.ProbabilityInfo;
	import com.sevenbrains.trashingDead.models.trade.info.StatsInfo;
	import com.sevenbrains.trashingDead.models.trade.info.StockInfo;
	import com.sevenbrains.trashingDead.models.utils.IOperationContext;
	import com.sevenbrains.trashingDead.processor.ICostProcessor;
	import com.sevenbrains.trashingDead.processor.ITradeValueProcessor;
	import com.sevenbrains.trashingDead.processor.PROCESSORS;
	
	import flash.utils.Dictionary;
	
	public class MultipleTradeValueProcessor implements ITradeValueProcessor {
		
		private static var _instance:MultipleTradeValueProcessor = null;
		private static var _instanciable:Boolean = false;
		
		public static function get instance():MultipleTradeValueProcessor {
			if (!_instance) {
				_instanciable = true;
				_instance = new MultipleTradeValueProcessor();
				_instanciable = false;
			}
			return _instance;
		}
			
		public function MultipleTradeValueProcessor() {
			if (!_instanciable) {
				throw new PrivateConstructorException("This is a singleton class");
			}
			initVars();
		}
		
		public function canProcess(value:ITradeValue, quantity:int = 1, context:IOperationContext = null):Boolean {
			if (value == null)
				return true;
			
			var multipleTradeValue:MultipleTradeValue = value as MultipleTradeValue;
			
			for each (var value:ITradeValue in multipleTradeValue.values) {
				if (!ICostProcessor(PROCESSORS[value.type]).canProcess(value, quantity, context)) {
					return false;
				}
			}
			
			return true;
		}
		
		public function preProcessCost(value:ITradeValue, context:IOperationContext = null, preprocess:Boolean = false):Vector.<ITradeValue> {
			if (!preprocess)
				return Vector.<ITradeValue>(MultipleTradeValue(value).values);
			var newValues:Vector.<ITradeValue> = new Vector.<ITradeValue>();
			
			for each (var tradeValue:ITradeValue in MultipleTradeValue(value).values) {
				if (tradeValue.canBeModified()) {
					var processor:ICostProcessor = PROCESSORS[tradeValue.type] as ICostProcessor;
					newValues = newValues.concat(processor.preProcessCost(tradeValue, context, preprocess));
				} else {
					newValues = newValues.concat(MultipleTradeValue(value).values);
				}
			}
			
			return newValues;
		}
		
		public function preProcessReward(value:ITradeValue, context:IOperationContext = null, preprocess:Boolean = false):Vector.<ITradeValue> {
			if (!preprocess)
				return Vector.<ITradeValue>([value]);
			var newValues:Vector.<ITradeValue> = new Vector.<ITradeValue>();
			
			for each (var tradeValue:ITradeValue in MultipleTradeValue(value).values) {
				if (tradeValue.canBeModified()) {
					var processor:IRewardProcessor = PROCESSORS[tradeValue.type] as IRewardProcessor;
					newValues = newValues.concat(processor.preProcessReward(tradeValue, context, preprocess));
				} else {
					newValues.push(tradeValue);
				}
			}
			
			return newValues;
		}
		
		public function processCost(value:ITradeValue, context:IOperationContext = null):Vector.<ITradeValue> {
			var multipleTradeValue:MultipleTradeValue = MultipleTradeValue(value);
			
			if (!multipleTradeValue) {
				throw new InvalidArgumentException("MultipleTradeValueProcessor expects a MultipleTradeValue");
			}
			
			var values:Vector.<ITradeValue> = new Vector.<ITradeValue>();
			
			for each (var value:ITradeValue in multipleTradeValue.values) {
				values = values.concat(ICostProcessor(PROCESSORS[value.type]).processCost(value, context));
			}
			
			return values;
		}
		
		public function processReward(value:ITradeValue, context:IOperationContext = null):Vector.<ITradeValue> {
			var multipleTradeValue:MultipleTradeValue = MultipleTradeValue(value);
			
			if (!multipleTradeValue) {
				throw new InvalidArgumentException("MultipleTradeValueProcessor expects a MultipleTradeValue");
			}
			
			var values:Vector.<ITradeValue> = new Vector.<ITradeValue>();
			
			for each (var value:ITradeValue in multipleTradeValue.values) {
				values = values.concat(PROCESSORS[value.type]).processReward(value, context));
			}
			
			return values;
		}

	}
}