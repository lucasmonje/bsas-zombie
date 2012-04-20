package client 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Canvas
	{
		private static var _instance:Canvas;
		private static var _instanciable:Boolean;
		
		public static function get instance():Canvas 
		{
			if (!_instance){
				_instanciable = true;
				_instance = new Canvas();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		private var _root:Sprite;
		
		private var _world:Sprite;
		private var _hud:Sprite;
		
		public function Canvas() 
		{
			if (!_instanciable) {
				throw new Error("This is a singleton class!");
			}
			
			_world = new Sprite();
			_hud = new Sprite();
			
		}
		
		public function init(root:Sprite):void {
			_root = root;
			
			_root.addChild(_world);
			_root.addChild(_hud);
		}
		
		public function get world():Sprite 
		{
			return _world;
		}
		
		public function get hud():Sprite 
		{
			return _hud;
		}
		
		public function destroy():void {
			_world = null;
			_hud = null;
		}
		
	}

}