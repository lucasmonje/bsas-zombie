//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.execute.actions {
	
	import com.sevenbrains.trashingDead.execute.definition.UIActionDefinition;
	import com.sevenbrains.trashingDead.execute.IAction;
	import com.sevenbrains.trashingDead.execute.IActionDefinition;
	
	public class UIAction implements IAction {
		
		public function UIAction() {
		
		}
		
		public function execute(iDef:IActionDefinition):void {
			var def:UIActionDefinition = iDef as UIActionDefinition;
		}
	}
}