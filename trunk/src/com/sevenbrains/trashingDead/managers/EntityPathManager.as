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
		
		private var _entity:Entity;
		private var _pointsPath:PointsPath;
		
		private var _callId:int;
		
		public function EntityPathManager() 
		{
			
		}
		
		public function init():void {
			_content = new Sprite();
			_pointsPath = new PointsPath();
			
			_content.addChild(_pointsPath);
			
			_callId = GameTimer.instance.callMeEvery(200, update);
		}
		
		public function regist(entity:Entity):void {
			_entity = entity;
			
			_pointsPath.clear();
		}
		
		private function update():void {
			if (_entity && !_entity.isDestroyed()) {
				_pointsPath.addPoint(_entity.getItemPosition());
			}
		}
		
		public function destroy():void {
			while (_content.numChildren > 0) {
				_content.removeChildAt(0);
			}
			
			_pointsPath.destroy();
			
			_pointsPath = null;
			_entity = null;
			
			GameTimer.instance.cancelCall(_callId);
		}
		
		public function get content():Sprite 
		{
			return _content;
		}
	}

}