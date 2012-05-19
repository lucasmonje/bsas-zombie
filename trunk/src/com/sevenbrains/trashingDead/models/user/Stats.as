//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.models.user {
	
	import com.sevenbrains.trashingDead.events.PropertyChangeEvent;
	import com.sevenbrains.trashingDead.interfaces.IStats;
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class Stats extends EventDispatcher implements IStats {
		
		public static const COINS:String = "coins";
		public static const CREDITS:String = "credits";
		public static const XP:String = "xp";
		public static const VALID_STATS:Array = [COINS,CREDITS,XP];
		
		protected var _statsValues:Dictionary;
		
		public function Stats() {
			_statsValues = new Dictionary();
		}
		
		public function add(stats:IStats):IStats {
			var externalValues:Dictionary = stats.statsValues;
			
			for (var key:String in externalValues) {
				set(key, (_statsValues[key] || 0) + stats.get(key));
					//trace("Stats :: add :: key :: " + key + ": " +((_statsValues[key] || 0) + stats.get(key) ))
			}
			return this;
		}
		
		public function canAdd(stats:IStats, quantity:int = 1):Boolean {
			return true;
		}
		
		public function canSubstract(other:IStats, quantity:int = 1):Boolean {
			var value:int;
			var otherValue:int;
			var externalValues:Dictionary = other.statsValues;
			
			for (var key:String in externalValues) {
				
				value = _statsValues[key];
				otherValue = other.get(key);
				
				if (value < otherValue) {
					return false;
				}
			}
			return true;
		}
		
		public function copy():IStats {
			var copy:Stats = new Stats();
			var copier:ByteArray = new ByteArray();
			copier.writeObject(_statsValues);
			copier.position = 0;
			copy._statsValues = copier.readObject() as Dictionary;
			return copy;
		}
		
		public function get(key:String):int {
			return _statsValues[key];
		}
		
		public function set(key:String, value:int):void {
			if (_statsValues[key] == value) {
				return;
			}
			
			var oldValue:int = _statsValues[key];
			_statsValues[key] = value;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGED, key, oldValue, value));
		}
		
		public function get statsValues():Dictionary {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(_statsValues);
			copier.position = 0;
			return (copier.readObject()) as Dictionary;
		}
		
		public function subtract(stats:IStats):IStats {
			var externalValues:Dictionary = stats.statsValues;
			
			for (var key:String in externalValues) {
				set(key, (_statsValues[key] || 0) - stats.get(key));
			}
			return this;
		}
		
		override public function toString():String {
			var str:String = "[Stats ";
			
			for (var key:String in _statsValues) {
				if (get(key) != 0) {
					str += key + ": " + get(key) + " ";
				}
			}
			return str + "]";
		}
	}
}