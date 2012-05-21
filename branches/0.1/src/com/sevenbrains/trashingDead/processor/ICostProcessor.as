//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.processor {
	
	import com.sevenbrains.trashingDead.models.trade.ITradeValue;
	import com.sevenbrains.trashingDead.models.utils.IOperationContext;
	
	public interface ICostProcessor {
		
		/**
		 * Evaluates if the trade value can be processed
		 * @param value ITradeValue to be evaluated
		 * @param quantity amount of operations to be evaluated
		 * @param context contextual values to be used in the transaction if the evaluation succeed
		 * @return Boolean
		 *
		 */
		function canProcess(value:ITradeValue, quantity:int = 1, context:IOperationContext = null):Boolean;
		
		/**
		 * Executes the trade pre process
		 * @param value ITradeValue to be executed
		 * @param context contextual values to be used in the transaction
		 * @return a modified reward
		 *
		 */
		function preProcessCost(value:ITradeValue, context:IOperationContext = null, preprocess:Boolean = false):Vector.<ITradeValue>;
		/**
		 * Executes the trade transaction
		 * @param value ITradeValue to be executed
		 * @param context contextual values to be used in the transaction
		 * @return a Vector of ITradeValue with the processed values
		 *
		 */
		function processCost(value:ITradeValue, context:IOperationContext = null):Vector.<ITradeValue>;
	}
}