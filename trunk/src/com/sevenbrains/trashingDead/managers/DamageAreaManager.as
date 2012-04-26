package com.sevenbrains.trashingDead.managers 
{
	import com.sevenbrains.trashingDead.definitions.ItemDamageAreaDefinition;
	import com.sevenbrains.trashingDead.entities.DamageArea;
	import com.sevenbrains.trashingDead.events.GameTimerEvent;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class DamageAreaManager
	{
		private static var _instance:DamageAreaManager = null;
		private static var _instanciable:Boolean = false;
		
		public static function get instance():DamageAreaManager {
			if (!_instance) {
				_instanciable = true;
				_instance = new DamageAreaManager();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		private var _damageAreas:Vector.<DamageArea>;
		
		private var _content:Sprite;
				
		public function DamageAreaManager() 
		{
			if (!_instanciable) {
				throw new Error("This is a singleton class");
			}
		}
		
		public function init():void {
			_damageAreas = new Vector.<DamageArea>();
			_content = new Sprite();
			GameTimer.instance.addEventListener(GameTimerEvent.TIME_UPDATE_SECOND, update);
		}
		
		public function addDamageArea(pos:Point, props:ItemDamageAreaDefinition):void {
			var damageArea:DamageArea = new DamageArea(pos, props);
			
			_content.addChild(damageArea.content);
			
			_damageAreas.push(damageArea);
		}
		
		public function get content():Sprite 
		{
			return _content;
		}
		
		public function update(e:GameTimerEvent):void {
			var i:int = 0;
			var damageArea:DamageArea;
			while (i < _damageAreas.length) {
				damageArea = _damageAreas[i];
				if (--damageArea.times == 0) {
					_content.removeChild(damageArea.content);
					_damageAreas.splice(i, 1);
				}else {
					i++;
				}
			}
		}
		
		public function destroy():void {
			GameTimer.instance.removeEventListener(GameTimerEvent.TIME_UPDATE_SECOND, update);
			while (_content.numChildren > 0) {
				_content.removeChildAt(0);
			}
			for each (var damageArea:DamageArea in _damageAreas) {
				damageArea.destroy();
			}
			_damageAreas = null;
			_content = null;
		}
	}

}