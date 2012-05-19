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
	import com.sevenbrains.trashingDead.models.utils.ISingleInfo;
	
	public interface ITradeValue extends IModifiable {
		
		function addToTradeValueInfo(info:TradeValueInfo):void;
		
		/**
		 * @return a ITradeValueInfo with the data of the trade value and its children accumulated (if apply)
		 */
		function get info():TradeValueInfo;
		
		/**
		 * Saves a ITradeValueInfo with the data of the trade value and its children accumulated (if apply)
		 */
		function set info(value:TradeValueInfo):void;
		
		/**
		 * @return a LockDefinition. TradeValue is ignored while is locked
		 */
		function get lock():LockDefinition;
		
		/**
		 * @return a LockDefinition. TradeValue is ignored while is locked
		 */
		function set lock(value:LockDefinition):void;
		
		/**
		 * @return a list of atomic parts
		 */
		function get singleInfos():Vector.<ISingleInfo>;
	}
}