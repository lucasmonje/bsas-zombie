//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------
package com.sevenbrains.trashingDead.managers {
	
	import com.sevenbrains.trashingDead.condition.ItemConditionChecker;
	import com.sevenbrains.trashingDead.condition.StatsConditionChecker;
	import com.sevenbrains.trashingDead.condition.core.ConditionDefinition;
	import com.sevenbrains.trashingDead.condition.core.IConditionChecker;
	import com.sevenbrains.trashingDead.definitions.LockDefinition;
	import com.sevenbrains.trashingDead.enum.ConditionsType;
	import com.sevenbrains.trashingDead.exception.PrivateConstructorException;
	import com.sevenbrains.trashingDead.exception.UnsupportedOperationException;
	
	import flash.utils.Dictionary;
	
	
	public class LockManager {
		
		private static var _instance:LockManager;
		
		private static var instanciationEnabled:Boolean;
		
		private var conditionCheckers:Dictionary;
		
		private var locksById:Dictionary;
		
		private var unlockedLocks:Dictionary;
		
		public function LockManager() {
			if (!instanciationEnabled) {
				throw new PrivateConstructorException("LockManager is a singleton class, use instance instead");
			}
			initVars();
		}
		
		private function initVars():void {
			locksById = new Dictionary();
			unlockedLocks = new Dictionary();
			conditionCheckers = new Dictionary();
			conditionCheckers[ConditionsType.ITEM] = new ItemConditionChecker();
			conditionCheckers[ConditionsType.STATS] = new StatsConditionChecker();
		}
		
		public function addLock(lock:LockDefinition):void {
			locksById[lock.id] = lock;
		}
		
		public function buyLock(lock:LockDefinition):void {
			if (lock.id < 0) {
				throw new UnsupportedOperationException("Could not buy lock without id");
			}
			//TODO: LOCKMANAGER
		}
		
		public function getFulfilledConditions(lock:LockDefinition):Array {
			var infos:Array = new Array();
			
			if (!lock) {
				return infos;
			}
			var checker:IConditionChecker;
			
			for each (var condition:ConditionDefinition in lock.conditions) {
				checker = conditionCheckers[condition.checkerId];
				
				if (!checker) {
					throw new UnsupportedOperationException(condition.checkerId + " is not a valid condition checker");
				}
				infos = infos.concat(checker.getFulfilledConditions(condition));
			}
			return infos;
		}
		
		public function getLock(id:int):LockDefinition {
			return locksById[id];
		}
		
		public function getMissingConditions(lock:LockDefinition):Array {
			var infos:Array = new Array();
			
			if (!lock) {
				return infos;
			}
			var checker:IConditionChecker;
			
			for each (var condition:ConditionDefinition in lock.conditions) {
				checker = conditionCheckers[condition.checkerId];
				
				if (!checker) {
					throw new UnsupportedOperationException(condition.checkerId + " is not a valid condition checker");
				}
				infos = infos.concat(checker.getMissingConditions(condition));
			}
			return infos;
		}
		
		public function isBuyable(lock:LockDefinition):Boolean {
			//TODO: LOCKMANAGER
			return false;
		}
		
		/**
		 * Check lock conditions and earlyUnlock and return locked status
		 * @param lock LockDefinition
		 * @return a Boolean with locked status (true if the lock is open);
		 */
		public function isLocked(lock:LockDefinition):Boolean {
			if (!lock) {
				return false;
			}
			
			//if its in the unlocked cache return false
			if (unlockedLocks[lock]) {
				return false;
			}
			
			//if it has no conditions, means that its allways locked, return true
			if (lock.conditions.length == 0) {
				return true;
			}
			//check if any conditions is not met, return true
			var checker:IConditionChecker;
			
			for each (var condition:ConditionDefinition in lock.conditions) {
				checker = conditionCheckers[condition.checkerId];
				
				if (!checker) {
					throw new UnsupportedOperationException(condition.checkerId + " is not a valid condition checker");
				}
				
				if (!checker.checkCondition(condition)) {
					return true;
				}
			}
			return false;
		}
		
		public function unlockIds(ids:Array):void {
			var lock:LockDefinition;
			
			for each (var id:int in ids) {
				lock = getLock(id);
				unlockedLocks[lock] = true;
			}
		}
		
		public static function get instance():LockManager {
			if (!_instance) {
				instanciationEnabled = true;
				_instance = new LockManager();
				instanciationEnabled = false;
			}
			return _instance;
		}
	}
}