//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.interfaces {
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public interface IStats extends IEventDispatcher {
		/**
		 * Adds the attributes of another stats to the attributes of this stats object.
		 * @param The stats object to be added.
		 * @return This stats.
		 */
		function add(stats:IStats):IStats;
		
		/**
		 * This method determines if a Istat instance can be added to this instance.
		 *
		 * @param stats  IStats instance to be evaluated
		 * @param quantity. The amount of stats to be evaluated, used for multiple operations.
		 * @return a boolean value. True if it is determined that you can add or false if it is determined that you can not
		 *
		 */
		function canAdd(stats:IStats, quantity:int = 1):Boolean;
		
		/**
		 * This method determines if a Istat instance can be subtracted from this instance.
		 *
		 * @param stats  IStats instance to be evaluated
		 * @param quantity. The amount of stats to be evaluated, used for multiple operations.
		 * @return a boolean value. True if it is determined that you can remove or false if it is determined that you can not
		 *
		 */
		function canSubstract(stats:IStats, quantity:int = 1):Boolean;
		
		function copy():IStats;
		
		/**
		 * Retrives an individual attribute value from its key
		 * @param	key an individual attribute key/name/id
		 * @return	the attribute value
		 */
		function get(key:String):int;
		
		/**
		 *
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		function set(key:String, value:int):void;
		
		/**
		 * Returns an instance with the map of established values.
		 * @return
		 *
		 */
		function get statsValues():Dictionary;
		
		/**
		 * Subtracts the attributes of another stats from the attributes of this stats object.
		 * @param The stats object to be subtracted.
		 * @return This stats.
		 */
		function subtract(stats:IStats):IStats;
	}

}