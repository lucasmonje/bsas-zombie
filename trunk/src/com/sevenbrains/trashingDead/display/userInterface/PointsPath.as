package com.sevenbrains.trashingDead.display.userInterface 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Fulvio
	 */
	public final class PointsPath extends Sprite 
	{
		private var _drawingRealTime:Boolean;
		
		private var _points:Vector.<Point>;
		
		public function PointsPath() 
		{
			_drawingRealTime = true;
			_points = new Vector.<Point>();
		}
		
		/**
		 * Establece si se va dibujando el camino a medida que se van agregando los puntos
		 * @param	value
		 */
		public function drawInRealTime(value:Boolean):void {
			_drawingRealTime = value;
		}
		
		/**
		 * Agrega una posicion
		 * @param	p
		 */
		public function addPoint(p:Point):void {
			_points.push(p);
			if (_drawingRealTime) {
				drawPoint(p);
			}
		}
		
		/**
		 * Dibuja un punto en la posicion dada
		 * @param	p
		 */
		private function drawPoint(p:Point):void {
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(p.x, p.y, 5);
			this.graphics.endFill();
		}
		
		/**
		 * Dibuja el camino
		 */
		public function drawPath():void {
			clear();
			this.graphics.beginFill(0xff0000);
			for each(var p:Point in _points) {
				this.graphics.drawCircle(p.x, p.y, 5);
			}
			this.graphics.endFill();
		}
		
		public function clear():void {
			this.graphics.clear();
		}
		
		public function destroy():void {
			_points = null;
		}
	}

}