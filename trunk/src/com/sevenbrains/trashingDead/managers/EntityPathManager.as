package com.sevenbrains.trashingDead.managers 
{
	import com.sevenbrains.trashingDead.display.userInterface.PointsPath;
	import com.sevenbrains.trashingDead.entities.Entity;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * Clase que se dedica a dibujar el camino que realiza cada entidad registrada
	 * @author Fulvio
	 */
	public final class EntityPathManager 
	{
		private var _content:Sprite;
		
		private var _entities:Vector.<Entity>;
		private var _pointsPath:Vector.<PointsPath>;
		
		private var _callId:int;
		
		public function EntityPathManager() 
		{
			
		}
		
		public function init():void {
			_entities = new Vector.<Entity>();
			_content = new Sprite();
			
			_callId = GameTimer.instance.callMeEvery(200, update);
		}
		
		public function regist(entity:Entity):void {
			_entities.push(entity);
			_pointsPath.push(new PointsPath());
			_content.addChild(_pointsPath[_pointsPath.length - 1]);
		}
		
		private function update():void {
			var i:int = 0;
			var entity:Entity;
			var pointsPath:PointsPath;
			while (i < _entities.length) {
				entity = _entities[i];
				if (entity.isDestroyed()) {
					_entities.splice(i, 1);
					_content.removeChild(_pointsPath[i]);
					_pointsPath.splice(i, 1);
				}else {
					pointsPath.addPoint(entity.getItemPosition());
					i++;
				}
			}
		}
		
		public function destroy():void {
			while (_content.numChildren > 0) {
				_content.removeChildAt(0);
			}
			
			for each(var pointsPath:PointsPath in _pointsPath) {
				pointsPath.destroy();
			}
			
			_pointsPath = null;
			_entities = null;
			
			GameTimer.instance.cancelCall(_callId);
		}
		
		public function get content():Sprite 
		{
			return _content;
		}
	}

}