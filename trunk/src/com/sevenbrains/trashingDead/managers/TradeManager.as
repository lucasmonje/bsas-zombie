//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.managers {
	
	import com.sevenbrains.trashingDead.exception.InvalidArgumentException;
	import com.sevenbrains.trashingDead.exception.PrivateConstructorException;
	import com.sevenbrains.trashingDead.models.trade.ITradeValue;
	import com.sevenbrains.trashingDead.models.trade.TradeOperation;
	import com.sevenbrains.trashingDead.models.trade.TradeValueInfo;
	import com.sevenbrains.trashingDead.processor.ICostProcessor;
	import com.sevenbrains.trashingDead.processor.IRewardProcessor;
	import com.sevenbrains.trashingDead.processor.ITradeValuePostProcessor;
	import com.sevenbrains.trashingDead.models.utils.IOperationContext;
	
	import flash.utils.Dictionary;
	
	public class TradeManager {
		
		private static var _instance:TradeManager = null;
		private static var _instanciable:Boolean = false;
		
		public static function get instance():TradeManager {
			if (!_instance) {
				_instanciable = true;
				_instance = new TradeManager();
				_instanciable = false;
			}
			return _instance;
		}
		
		private var _costProcessorsMap:Dictionary;
		private var _lockManager:LockManager;
		private var _postProcessors:Dictionary;
		private var _rewardProcessorsMap:Dictionary;
		
		public function TradeManager() {
			if (!_instanciable) {
				throw new PrivateConstructorException("This is a singleton class");
			}
			_lockManager = LockManager.instance;
		}
		
		public function canProcessCost(value:ITradeValue, quantity:int = 1, context:IOperationContext = null, applyModifiers:Boolean = false):Boolean {
			if (!value) {
				return true;
			}
			
			if (_lockManager.isLocked(value.lock)) {
				return true;
			}
			
			var values:Vector.<ITradeValue> = getCostProcessor(value).preProcessCost(value, context, applyModifiers);
			
			for each (var v:ITradeValue in values) {
				if (!_lockManager.isLocked(v.lock)) {
					if (!getCostProcessor(v).canProcess(v, quantity, context)) {
						return false;
					}
				}
			}
			
			return true;
		}
		
		public function processCost(value:ITradeValue, quantity:int = 1, context:IOperationContext = null, applyModifiers:Boolean = false):TradeValueInfo {
			if (!value) {
				return null;
			}
			
			if (_lockManager.isLocked(value.lock)) {
				return new TradeValueInfo();
			}
			
			var values:Vector.<ITradeValue> = getCostProcessor(value).preProcessCost(value, context, applyModifiers);
			var result:Vector.<ITradeValue> = new Vector.<ITradeValue>();
			
			var tradeInfo:TradeValueInfo = new TradeValueInfo();
			var v:ITradeValue;
			
			for (var i:int = 0; i < quantity; i++) {
				for each (v in values) {
					if (!_lockManager.isLocked(v.lock)) { // check lock in preprocessed value
						result = result.concat(getCostProcessor(v).processCost(v, context));
					}
				}
			}
			
			for each (v in result) {
				tradeInfo.addTradeValue(v);
			}
			
			for each (var strategy:ITradeValuePostProcessor in _postProcessors) {
				strategy.process(value, tradeInfo, TradeOperation.REMOVE, context);
			}
			
			return tradeInfo;
		}
		
		private function getCostProcessor(value:ITradeValue):ICostProcessor {
			var costProcessor:ICostProcessor = _costProcessorsMap[value.type];
			
			if (!costProcessor) {
				var msg:String = "TradeManager can't find a costProcessor for type:" + value.type;
				throw new InvalidArgumentException(msg);
			}
			return costProcessor;
		}
		
		private function getRewardProcessor(value:ITradeValue):IRewardProcessor {
			var rewardProcessor:IRewardProcessor = _rewardProcessorsMap[value.type];
			
			if (!rewardProcessor) {
				var msg:String = "TradeManager can't find a rewardProcessor for type:" + value.type;
				throw new InvalidArgumentException(msg);
			}
			return rewardProcessor;
		}
	}
}