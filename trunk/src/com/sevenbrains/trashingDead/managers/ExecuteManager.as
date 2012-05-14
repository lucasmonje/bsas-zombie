//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.managers {
	
	import com.sevenbrains.trashingDead.definitions.ExecuteDefinition;
	import com.sevenbrains.trashingDead.exception.UnsupportedOperationException;
	import com.sevenbrains.trashingDead.execute.interfaces.IAction;
	import com.sevenbrains.trashingDead.execute.interfaces.IActionDefinition;
	
	import flash.utils.Dictionary;
	
	public class ExecuteManager {
	
		public var actions:Dictionary;
		
		protected var executesById:Dictionary;
		
		public function ExecuteManager() {
			executesById = new Dictionary();
		}
		
		public function execute(execute:ExecuteDefinition):Boolean {
			if (!execute) {
				return false;
			}
			
			var action:IAction;
			
			for each (var actionDef:IActionDefinition in execute.actions) {
				action = actions[actionDef.actionId];
				
				if (!action) {
					throw new UnsupportedOperationException(actionDef.actionId + " is not a valid Action.");
				}
				action.execute(actionDef);
			}
			return true;
		}
	}
}