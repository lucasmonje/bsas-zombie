//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.definitions {
	
	public class SuggestionDefinition {
		
		private var _execute:ExecuteDefinition;
		
		private var _id:String;
		
		private var _lock:LockDefinition;
		
		private var _name:String;
		
		private var _persist:Boolean;
		
		private var _url:String;
		
		public function SuggestionDefinition() {
		}
		
		public function get execute():ExecuteDefinition {
			return _execute;
		}
		
		public function set execute(value:ExecuteDefinition):void {
			_execute = value;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
		
		public function get lock():LockDefinition {
			return _lock;
		}
		
		public function set lock(value:LockDefinition):void {
			_lock = value;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
		public function get persist():Boolean {
			return _persist;
		}
		
		public function set persist(value:Boolean):void {
			_persist = value;
		}
		
		public function get url():String {
			return _url;
		}
		
		public function set url(value:String):void {
			_url = value;
		}
	}
}