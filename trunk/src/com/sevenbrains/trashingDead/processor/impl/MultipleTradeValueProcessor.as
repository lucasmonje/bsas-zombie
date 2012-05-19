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
	import com.sevenbrains.trashingDead.models.utils.IOperationContext;
	import com.sevenbrains.trashingDead.processor.ICostProcessor;
	import com.sevenbrains.trashingDead.processor.ITradeValueProcessor;
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
		
		protected var _costProcessorsMap:Dictionary;
		protected var _rewardProcessorsMap:Dictionary;
		
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
				if (!ICostProcessor(_costProcessorsMap[value.type]).canProcess(value, quantity, context)) {
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
					var processor:ICostProcessor = _costProcessorsMap[tradeValue.type] as ICostProcessor;
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
					var processor:IRewardProcessor = _rewardProcessorsMap[tradeValue.type] as IRewardProcessor;
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
				values = values.concat(ICostProcessor(_costProcessorsMap[value.type]).processCost(value, context));
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
				values = values.concat(IRewardProcessor(_rewardProcessorsMap[value.type]).processReward(value, context));
			}
			
			return values;
		}
		
		private function initVars():void {
		
		}
	}
}