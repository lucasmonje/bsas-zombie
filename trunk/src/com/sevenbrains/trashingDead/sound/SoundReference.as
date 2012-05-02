package com.sevenbrains.trashingDead.sound {
	
	public class SoundReference {
		
		private var _id:String;
		
		public function SoundReference() {
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
	}
}