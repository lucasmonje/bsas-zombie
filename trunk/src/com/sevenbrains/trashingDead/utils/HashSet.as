//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.utils {
	
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public class HashSet extends Proxy {
		
		private var _size:int;
		private var array:Array;
		private var hash:Dictionary;
		private var indexes:Dictionary;
		
		public function HashSet() {
			hash = new Dictionary();
			indexes = new Dictionary();
			array = [];
			_size = 0;
		}
		
		public function add(item:*):Boolean {
			var _item:* = hash[item];
			
			if (_item == null) {
				hash[item] = item;
				indexes[item] = _size;
				array.push(item);
				_size++;
				return true;
			}
			return false;
		}
		
		public function addAll(items:Array):void {
			for each (var item:* in items) {
				add(item);
			}
		}
		
		public function clear():Boolean {
			hash = new Dictionary();
			indexes = new Dictionary();
			array = [];
			return true;
		}
		
		public function has(item:*):Boolean {
			return hash[item] != null;
		}
		
		public function remove(item:*):Boolean {
			var _item:* = hash[item];
			
			if (_item == null) {
				return false;				
			}
			delete hash[item];
			var index:int = indexes[item];
			delete indexes[item];
			array.splice(index, 1);
			reorganize(index);
			_size--;
			return true;
		}
		
		public function get size():int {
			return _size;
		}
		
		public function toArray():Array {
			return array.concat();
		}
		
		flash_proxy override function nextName(index:int):String {
			return String(index - 1);
		}
		
		flash_proxy override function nextNameIndex(index:int):int {
			return index >= _size ? 0 : index + 1;
		}
		
		flash_proxy override function nextValue(index:int):* {
			return array[index - 1];
		}
		
		private function reorganize(index:int):void {
			for (var i:int = index; i < array.length; i++) {
				var item:* = array[i];
				indexes[item] = i;
			}
		}
	}
}