package com.sevenbrains.trashingDead.managers
{
	import com.sevenbrains.trashingDead.exception.PrivateConstructorException;

	public class TradeManager
	{
		private static var _instance:TradeManager = null;
		private static var _instanciable:Boolean = false;
		public function TradeManager()
		{
			if (!_instanciable) {
				throw new PrivateConstructorException("This is a singleton class");
			}
		}
		
		public static function get instance():TradeManager {
			if (!_instance) {
				_instanciable = true;
				_instance = new TradeManager();
				_instanciable = false;
			}
			return _instance;
		}
	}
}