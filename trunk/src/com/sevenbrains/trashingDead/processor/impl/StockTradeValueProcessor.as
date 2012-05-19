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
	import com.sevenbrains.trashingDead.interfaces.IClassifiable;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.models.trade.ITradeValue;
	import com.sevenbrains.trashingDead.models.trade.StockTradeValue;
	import com.sevenbrains.trashingDead.models.utils.IOperationContext;
	import com.sevenbrains.trashingDead.processor.ITradeValueProcessor;
	
	public class StockTradeValueProcessor implements ITradeValueProcessor {
		
		private static var _instance:StockTradeValueProcessor = null;
		private static var _instanciable:Boolean = false;
		
		public static function get instance():StockTradeValueProcessor {
			if (!_instance) {
				_instanciable = true;
				_instance = new StockTradeValueProcessor();
				_instanciable = false;
			}
			return _instance;
		}
		
		public function StockTradeValueProcessor() {
			if (!_instanciable) {
				throw new PrivateConstructorException("This is a singleton class");
			}
		}
		
		public function canProcess(value:ITradeValue, quantity:int = 1, context:IOperationContext = null):Boolean {
			var stockTradeValue:StockTradeValue = StockTradeValue(value);
			
			if (!stockTradeValue) {
				throw new InvalidArgumentException("StockTradeValueProcessor expects a StockTradeValue");
			}
			
			var currentQuantity:int = UserModel.instance.inventory.getItemQuantityByCode(stockTradeValue.code);
			return currentQuantity >= (stockTradeValue.quantity * quantity);
		}
		
		public function preProcessCost(value:ITradeValue, context:IOperationContext = null, preprocess:Boolean = false):Vector.<ITradeValue> {
			return Vector.<ITradeValue>([value]);
		}
		
		public function preProcessReward(value:ITradeValue, context:IOperationContext = null, preprocess:Boolean = false):Vector.<ITradeValue> {
			return Vector.<ITradeValue>([value]);
		}
		
		public function processCost(value:ITradeValue, context:IOperationContext = null):Vector.<ITradeValue> {
			var stockTradeValue:StockTradeValue = StockTradeValue(value);
			
			if (!stockTradeValue) {
				throw new InvalidArgumentException("StockTradeValueProcessor expects a StockTradeValue");
			}
			var item:IClassifiable = ConfigModel.items.getById(stockTradeValue.code);
			UserModel.instance.inventory.removeItem(item, stockTradeValue.quantity);
			
			return Vector.<ITradeValue>([value]);
		}
		
		public function processReward(value:ITradeValue, context:IOperationContext = null):Vector.<ITradeValue> {
			var stockTradeValue:StockTradeValue = StockTradeValue(value);
			
			if (!stockTradeValue) {
				throw new InvalidArgumentException("StockTradeValueProcessor expects a StockTradeValue");
			}
			var item:IClassifiable = ConfigModel.items.getById(stockTradeValue.code);
			
			UserModel.instance.inventory.addItem(item, stockTradeValue.quantity);
			
			return Vector.<ITradeValue>([value]);
		}
	}
}