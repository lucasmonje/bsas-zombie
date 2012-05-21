//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.models.trade {
	
	public class ProbabilityData {
		
		private var _probability:Number;
		private var _tradeValue:ITradeValue;
		
		public function ProbabilityData(probability:Number, tradeValue:ITradeValue) {
			_probability = probability;
			_tradeValue = tradeValue;
		}
		
		public function copy():ProbabilityData {
			return new ProbabilityData(probability, tradeValue.copy());
		}
		
		public function get probability():Number {
			return _probability;
		}
		
		public function get tradeValue():ITradeValue {
			return _tradeValue;
		}
	}
}