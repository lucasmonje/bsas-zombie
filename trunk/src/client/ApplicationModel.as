package client 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ApplicationModel 
	{
		
		private static var _instanciable:Boolean;
		private static var _instance:ApplicationModel;
		
		public function ApplicationModel() 
		{
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
			
			_map = new Dictionary();
		}
		
		public static function get instance():ApplicationModel {
			if (!_instance) {
				_instanciable = true;
				_instance = new ApplicationModel();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		private var _map:Dictionary;
		
		public function addMap(key:String, list:Array):void {
			_map[key] = list.concat();
		}
		
		public function getItems():Array {
			return _map[ConfigNodes.ITEMS];
		}
	}

}