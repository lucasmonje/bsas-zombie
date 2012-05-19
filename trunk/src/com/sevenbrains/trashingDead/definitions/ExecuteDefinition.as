//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.definitions {
	
	import com.sevenbrains.trashingDead.execute.IActionDefinition;
	import com.sevenbrains.trashingDead.utils.ClassUtil;
	
	import flash.utils.Dictionary;
	
	public class ExecuteDefinition {
		
		private var _actions:Vector.<IActionDefinition>;
		
		private var _actionsByType:Dictionary;
		
		public function ExecuteDefinition() {
			_actions = new Vector.<IActionDefinition>();
			_actionsByType = new Dictionary();
		}
		
		public function get actions():Vector.<IActionDefinition> {
			return _actions;
		}
		
		public function getActionDefinitionByType(type:Class):* {
			return _actionsByType[type];
		}
		
		public function addAction(action:IActionDefinition):void {
			_actions.push(action);
			_actionsByType[ClassUtil.getClass(action)] = action;
		}
	}
}