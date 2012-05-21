package com.sevenbrains.trashingDead.managers {
	
	import flash.events.EventDispatcher;
	
	/**
	* ...
	* @author Lucas Monje
	*/
	public class PreloaderManager extends EventDispatcher {
		
		private static var _instance:PreloaderManager;
		private static var instanciationEnabled:Boolean;
		
		public static function get instance():PreloaderManager {
			if (!_instance) {
				instanciationEnabled = true;
				_instance = new PreloaderManager();
				instanciationEnabled = false;
			}
			return _instance;
		}
		
		public function PreloaderManager() {
			if (!instanciationEnabled) {
				throw new Error("PreloaderManager is a singleton class, use instance property instead");				
			}
		}
	}
}