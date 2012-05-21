//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.execute.definition {
	
	import com.sevenbrains.trashingDead.enum.ActionsType;
	import com.sevenbrains.trashingDead.execute.IActionDefinition;
	
	public class PopupActionDefinition implements IActionDefinition {
		
		private var _actionId:String;
		
		private var _client:Object;
		
		private var _data:Object;
		
		private var _id:String;
		
		public function PopupActionDefinition() {
			_actionId = ActionsType.POPUP_ACTION;
		}
		
		public function get actionId():String {
			return _actionId;
		}
		
		public function get client():Object {
			return _client;
		}
		
		public function set client(value:Object):void {
			_client = value;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set data(value:Object):void {
			_data = value;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
	}
}