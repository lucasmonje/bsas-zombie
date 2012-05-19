//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.models.trade {
	
	import com.sevenbrains.trashingDead.definitions.LockDefinition;
	import com.sevenbrains.trashingDead.exception.AbstractMethodException;
	import com.sevenbrains.trashingDead.models.utils.ISingleInfo;
	
	public class AbstractTradeValue implements ITradeValue {
		
		protected var _info:TradeValueInfo;
		protected var _lock:LockDefinition;
		protected var _type:String;
		
		public function AbstractTradeValue() {
		}
		
		public function addToTradeValueInfo(info:TradeValueInfo):void {
		}
		
		public function canBeModified():Boolean {
			throw new AbstractMethodException("canBeModified");
			return false;
		}
		
		public function copy():ITradeValue {
			throw new AbstractMethodException("copy");
		}
		
		public function get info():TradeValueInfo {
			return _info;
		}
		
		public function set info(value:TradeValueInfo):void {
			_info = value;
		}
		
		public function get lock():LockDefinition {
			return _lock;
		}
		
		public function set lock(value:LockDefinition):void {
			_lock = value;
		}
		
		public function get possibleModifierEffects():Array {
			throw new AbstractMethodException("posibleModifierEffects");
			return [];
		}
		
		public function get singleInfos():Vector.<ISingleInfo> {
			throw new AbstractMethodException("get singleInfos");
		}
		
		public function get type():String {
			return _type;
		}
	}
}