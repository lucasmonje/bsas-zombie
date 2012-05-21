package com.sevenbrains.trashingDead.sound {
	
	public class SoundDefinition {
		
		private var _id:String;
		private var _stream:Boolean;
		private var _loops:int;
		private var _type:String;
		private var _path:String;
		
		public function SoundDefinition() {
		}
		
		public function get id():String {
			return _id;
		}
		
		public function get stream():Boolean {
			return _stream;
		}
		
		public function get loops():int {
			return _loops;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
		
		public function set stream(value:Boolean):void {
			_stream = value;
		}
		
		public function set loops(value:int):void {
			var loops:int = isFinite(value) ? int(value) : int.MAX_VALUE;
			_loops = (loops < 0 ? 0 : loops);
		}
		
		public function get type():String {
			return _type;
		}
		
		public function set type(value:String):void {
			_type = value;
		}
		
		public function get path():String {
			return _path;
		}
		
		public function set path(value:String):void {
			_path = value;
		}
	}
}