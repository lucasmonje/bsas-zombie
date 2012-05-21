package com.sevenbrains.trashingDead.sound {
	
	public class SoundActionDefinition {
		
		private var _type:String;
		private var _soundReferences:Vector.<SoundReference>;
		
		public function SoundActionDefinition() {
		}
		
		public function get type():String {
			return _type;
		}
		
		public function get soundReferencess():Vector.<SoundReference> {
			return _soundReferences;
		}
		
		public function set type(value:String):void {
			_type = value;
		}
		
		public function set soundReferences(value:Vector.<SoundReference>):void {
			_soundReferences = value;
		}
	}
}