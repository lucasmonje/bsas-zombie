package client 
{
	
	public class WorldModel {
		
		private var _currentWorld:World;
		
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
		
	}

}