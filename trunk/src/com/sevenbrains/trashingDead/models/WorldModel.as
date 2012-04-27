package com.sevenbrains.trashingDead.models 
{
	import com.sevenbrains.trashingDead.display.World;
	import flash.geom.Rectangle;
	
	public class WorldModel {
		
		private var _currentWorld:World;
		
		private var _floorRect:Rectangle;
		
		private static var _instanciable:Boolean;
		private static var _instance:WorldModel;
		
		public function WorldModel() {
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
		}
		
		public static function get instance():WorldModel {
			if (!_instance) {
				_instanciable = true;
				_instance = new WorldModel();
				_instanciable = false;
			}			
			return _instance;
		}
		
		public function get currentWorld():World 
		{
			return _currentWorld;
		}
		
		public function set currentWorld(value:World):void 
		{
			_currentWorld = value;
		}
		
		public function get floorRect():Rectangle 
		{
			return _floorRect;
		}
		
		public function set floorRect(value:Rectangle):void 
		{
			_floorRect = value;
		}
		
	}

}