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
	import com.sevenbrains.trashingDead.exception.PrivateConstructorException;
	import com.sevenbrains.trashingDead.models.trade.ITradeValue;
	import com.sevenbrains.trashingDead.models.trade.ProbabilityTradeValue;
	import com.sevenbrains.trashingDead.models.utils.IOperationContext;
	import com.sevenbrains.trashingDead.processor.IRewardProcessor;
	import flash.utils.Dictionary;
	
	public class ProbabilityRewardProcessor implements IRewardProcessor {
		
		private static var _instance:ProbabilityRewardProcessor = null;
		private static var _instanciable:Boolean = false;
		
		public static function get instance():ProbabilityRewardProcessor {
			if (!_instance) {
				_instanciable = true;
				_instance = new ProbabilityRewardProcessor();
				_instanciable = false;
			}
			return _instance;
		}
		
		public function ProbabilityRewardProcessor() {
			if (!_instanciable) {
				throw new PrivateConstructorException("This is a singleton class");
			}
		}
		
		public function preProcessReward(value:ITradeValue, context:IOperationContext = null, preprocess:Boolean = false):Vector.<ITradeValue> {
			return Vector.<ITradeValue>([value]);
		}
		
		public function processReward(value:ITradeValue, context:IOperationContext = null):Vector.<ITradeValue> {
			var probabilityTradeValue:ProbabilityTradeValue = ProbabilityTradeValue(value);
			
			if (!probabilityTradeValue) {
				throw new InvalidArgumentException("ProbabilityRewardProcessor expects a ProbabilityTradeValue");
			}
			return new Vector.<ITradeValue>();
		}
		
		protected function getRandomTradeValue(values:Vector.<ProbabilityData>, probability:int):ITradeValue {
			var p:int = 0;
			
			for each (var data:ProbabilityData in values) {
				p += data.probability;
				
				if (probability < p) {
					return data.tradeValue;
				}
			}
			return null;
		}
	}
}