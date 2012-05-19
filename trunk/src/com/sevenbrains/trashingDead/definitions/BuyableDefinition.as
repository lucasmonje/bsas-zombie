//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.definitions {
	
	import com.sevenbrains.trashingDead.models.trade.ITradeValue;
	
	public class BuyableDefinition {
		
		private var _cost:ITradeValue;
		private var _lockDefinition:LockDefinition;
		private var _name:String;
		private var _reward:ITradeValue;
		
		public function BuyableDefinition(name:String, cost:ITradeValue, reward:ITradeValue, lockDef:LockDefinition) {
			_name = name;
			_cost = cost;
			_reward = reward;
			_lockDefinition = lockDef;
		}
		
		public function get cost():ITradeValue {
			return _cost;
		}
		
		public function get lockDefinition():LockDefinition {
			return _lockDefinition;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get reward():ITradeValue {
			return _reward;
		}
	}
}