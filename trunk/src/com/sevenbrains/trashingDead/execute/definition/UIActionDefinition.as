//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.execute.definition {
	
	import com.sevenbrains.trashingDead.execute.interfaces.IActionDefinition;
	
	public class UIActionDefinition implements IActionDefinition {
		
		private var _actionId:String;
		
		private var _tab:String;
		
		public function UIActionDefinition() {
			_actionId = "uiAction";
		}
		
		public function get actionId():String {
			return _actionId;
		}
		
		public function get tab():String {
			return _tab;
		}
		
		public function set tab(value:String):void {
			_tab = value;
		}
	}
}