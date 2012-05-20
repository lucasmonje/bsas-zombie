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
		private var _reward:ITradeValue;
		
		public function BuyableDefinition(cost:ITradeValue, reward:ITradeValue, lockDef:LockDefinition) {
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
		
		public function get reward():ITradeValue {
			return _reward;
		}
	}
}