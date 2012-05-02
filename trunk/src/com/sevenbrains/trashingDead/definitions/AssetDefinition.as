package com.sevenbrains.trashingDead.definitions {
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public class AssetDefinition {
		
		private var _id:String;
		private var _type:String;
		private var _path:String;
		private var _preloaderId:String;
		
		public function AssetDefinition(id:String, type:String, path:String, preloaderId:String = null) {
			_id = id;
			_type = type;
			_path = path;
			_preloaderId = preloaderId;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function get path():String {
			return _path;
		}
		
		public function get preloaderId():String {
			return _preloaderId;
		}
		
		public function get type():String {
			return _type;
		}
	}
}