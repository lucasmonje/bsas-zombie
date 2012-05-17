//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.execute.actions {
	
	import com.sevenbrains.trashingDead.execute.definition.PopupActionDefinition;
	import com.sevenbrains.trashingDead.execute.interfaces.IAction;
	import com.sevenbrains.trashingDead.execute.interfaces.IActionDefinition;
	
	public class PopupAction implements IAction {
		
		public function PopupAction() {
		
		}
		
		public function execute(iDef:IActionDefinition):void {
			var def:PopupActionDefinition = iDef as PopupActionDefinition;
		}
	}
}