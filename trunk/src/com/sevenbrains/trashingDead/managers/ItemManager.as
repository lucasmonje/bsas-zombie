package com.sevenbrains.trashingDead.managers 
{
	import com.sevenbrains.trashingDead.entities.Entity;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemManager 
	{
		private static var _instance:ItemManager = null;
		private static var _instanciable:Boolean = false;
		
		public static function get instance():ItemManager {
			if (!_instance) {
				_instanciable = true;
				_instance = new ItemManager();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		private var _entityList:Vector.<Entity>;
		private var _callId:int;
		
		public function ItemManager() {
			if (!_instanciable) {
				throw new Error("This is a singleton class!");
			}
			
			_entityList = new Vector.<Entity>();
			_callId = GameTimer.instance.callMeEvery(1, update);
		}
		
		public function regist(entity:Entity):void {
			_entityList.push(entity);
		}
		
		public function unregist(entity:Entity):void {
			var i:int = 0;
			var e:Entity;
			while (i < _entityList.length) {
				e = _entityList[i];
				if (e == entity) {
					_entityList.splice(i, 1);
					return;
				}else {
					i++;
				}
			}
		}
		
		private function update():void {
			var i:int = 0;
			var entity:Entity;
			
			while (i < _entityList.length) {
				entity = _entityList[i];
				if (entity.isDestroyed()) {
					entity.destroy();
					_entityList.splice(i, 1);
				}else {
					i++;
				}
			}
		}
		
		public function getZombies():Array {
			var a:Array = [];
			for each (var e:Entity in _entityList) {
				if (e.type == PhysicObjectType.ZOMBIE || e.type == PhysicObjectType.FLYING_ZOMBIE) {
					a.push(e);
				}
			}
			return a;
		}
		
		public function getZombiesAmount():int {
			var zombies:Array = getZombies();
			return zombies.length;
		}
		
		private function destroyList(list:Vector.<Entity>):void {
			for each(var entity:Entity in list) {
				entity.destroy();
			}
		}
		
		public function destroy():void {
			destroyList(_entityList);
			_entityList = null;
			GameTimer.instance.cancelCall(_callId);
		}
	}

}