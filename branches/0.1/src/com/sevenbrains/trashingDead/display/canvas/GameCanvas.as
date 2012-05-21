package com.sevenbrains.trashingDead.display.canvas 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Fulvio
	 */
	public class GameCanvas
	{
		private static var _instance:GameCanvas=null;
		private static var _instanciable:Boolean=false;
		
		private var _world:Sprite;
		private var _hud:Sprite;
		private var _popup:Sprite;
		private var _loading:Sprite;
		
		public static function get instance():GameCanvas {
			if (!_instance) {
				_instanciable = true;
				_instance = new GameCanvas();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		public function GameCanvas() 
		{
			if (!_instanciable) {
				throw new Error("This is a singleton class!");
			}
			
			_world = new Sprite();
			_hud = new Sprite();
			_popup = new Sprite();
			_loading = new Sprite();
		}
		
		public function get world():Sprite 
		{
			return _world;
		}
		
		public function get hud():Sprite 
		{
			return _hud;
		}
		
		public function get popup():Sprite 
		{
			return _popup;
		}
		
		public function get loading():Sprite 
		{
			return _loading;
		}
		
	}

}