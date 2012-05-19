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
	import com.sevenbrains.trashingDead.enum.ActionsType;
	import com.sevenbrains.trashingDead.exception.PrivateConstructorException;
	import com.sevenbrains.trashingDead.exception.UnsupportedOperationException;
	import com.sevenbrains.trashingDead.execute.actions.*;
	import com.sevenbrains.trashingDead.execute.IAction;
	import com.sevenbrains.trashingDead.execute.IActionDefinition;
	
	import flash.utils.Dictionary;
	
	
	public class ExecuteManager {
		
		private static var _instance:ExecuteManager;
		
		private static var instanciationEnabled:Boolean;
		
		private var actions:Dictionary;
		
		private var executesById:Dictionary;
		
		public function ExecuteManager() {
			if (!instanciationEnabled) {
				throw new PrivateConstructorException("ExecuteManager is a singleton class, use instance instead");
			}
			initVars();
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
		
		private function initVars():void {
			executesById = new Dictionary();
			actions = new Dictionary();
			actions[ActionsType.POPUP_ACTION] = new PopupAction();
			actions[ActionsType.UI_ACTION] = new UIAction();
		}
		
		public static function get instance():ExecuteManager {
			if (!_instance) {
				instanciationEnabled = true;
				_instance = new ExecuteManager();
				instanciationEnabled = false;
			}
			return _instance;
		}
	}
}