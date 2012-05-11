//------------------------------------------------------------------------------
//
//	This software is the confidential and proprietary information of   
//	7 Brains. You shall not disclose such Confidential Information and   
//	shall use it only in accordance with the terms of the license   
//	agreement you entered into with 7 Brains.  
//	Copyright 2012 - 7 Brains. 
//	All rights reserved.  
//
//------------------------------------------------------------------------------
package com.sevenbrains.trashingDead.models {
	
	import com.sevenbrains.trashingDead.display.World;
	import com.sevenbrains.trashingDead.managers.PanZoom;
	import com.sevenbrains.trashingDead.managers.StageTimer;
	import flash.geom.Rectangle;
	import Box2D.Common.Math.b2Vec2;
	
	
	public class WorldModel {
		
		private static var _instance:WorldModel;
		
		private static var _instanciable:Boolean;
		
		private var _currentWorld:World;
		
		private var _floorRect:Rectangle;
		
		private var _gravity:b2Vec2;
		
		private var _panZoom:PanZoom;
		
		private var _stageTimer:StageTimer;
		
		public function WorldModel() {
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
		}
		
		public function get currentWorld():World {
			return _currentWorld;
		}
		
		public function set currentWorld(value:World):void {
			_currentWorld = value;
		}
		
		public function get floorRect():Rectangle {
			return _floorRect;
		}
		
		public function set floorRect(value:Rectangle):void {
			_floorRect = value;
		}
		
		public function get gravity():b2Vec2 {
			return _gravity.Copy();
		}
		
		public function set gravity(value:b2Vec2):void {
			_gravity = value;
		}
		
		public function get panZoom():PanZoom {
			return _panZoom;
		}
		
		public function set panZoom(value:PanZoom):void {
			_panZoom = value;
		}
		
		public function get stageTimer():StageTimer {
			return _stageTimer;
		}
		
		public function set stageTimer(value:StageTimer):void {
			_stageTimer = value;
		}
		
		public static function get instance():WorldModel {
			if (!_instance) {
				_instanciable = true;
				_instance = new WorldModel();
				_instanciable = false;
			}
			return _instance;
		}
	}
}