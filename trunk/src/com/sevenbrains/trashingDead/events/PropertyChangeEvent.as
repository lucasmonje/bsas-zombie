//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.events {
	
	import flash.events.Event;
	
	public class PropertyChangeEvent extends Event {
		
		public static const PROPERTY_CHANGED:String = "propertyChanged";
		
		private var _newValue:Object;
		private var _oldValue:Object;
		private var _property:String;
		
		public function PropertyChangeEvent(type:String, property:String, oldValue:Object, newValue:Object) {
			super(type);
			_property = property;
			_newValue = newValue;
			_oldValue = oldValue;
		}
		
		public function get newValue():Object {
			return _newValue;
		}
		
		public function get oldValue():Object {
			return _oldValue;
		}
		
		public function get property():String {
			return _property;
		}
	}
}