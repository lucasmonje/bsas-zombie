package com.sevenbrains.trashingDead.genetators 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.definitions.WorldEntitiesDefinition;
	import com.sevenbrains.trashingDead.entities.Entity;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.factories.ZombieFactory;
	import com.sevenbrains.trashingDead.managers.ItemManager;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.utils.MathUtils;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio
	 */
	public final class ZombieGenerator 
	{
		private var _time:int;
		private var _maximum:int;
		private var _worldZombiesDefinition:Vector.<WorldEntitiesDefinition>;
		private var _callId:int;
		
		public function ZombieGenerator() 
		{
			
		}
		
		public function init(time:int, maximum:int, worldZombiesDefinition:Vector.<WorldEntitiesDefinition>):void {
			_time = time;
			_maximum = maximum;
			_worldZombiesDefinition = worldZombiesDefinition.concat();
			_callId = GameTimer.instance.callMeEvery(_time, update);
			GameTimer.instance.pause();
		}
		
		public function activate(value:Boolean):void {
			if (value) {
				GameTimer.instance.resume();
			}else {
				GameTimer.instance.pause();
			}
		}
		
		private function update():void {
			if (ItemManager.instance.getZombiesAmount() < _maximum) {
				var wzd:WorldEntitiesDefinition;
				var code:uint;
				var weight:uint = 1;
				for each (wzd in _worldZombiesDefinition) {
					weight += wzd.weight;
				}
				var rnd:Number = MathUtils.getRandom(1, weight);
				weight = 1;
				for each (wzd in _worldZombiesDefinition) {
					weight += wzd.weight;
					if (rnd <= weight) {
						code = wzd.code;
						break;
					}
				}
				
				var zombieProps:ItemDefinition = ConfigModel.entities.getZombieByCode(code);
				if (zombieProps){
					var pos:Point;
					var floorY:Number = WorldModel.instance.floorRect.y - (WorldModel.instance.floorRect.height / 2);
					pos = new Point(1100, zombieProps.type ==  PhysicObjectType.FLYING_ZOMBIE?floorY - 150:floorY);
					
					var z:Entity = ZombieFactory.instance.createZombie(zombieProps, pos);
					ItemManager.instance.regist(z);
					WorldModel.instance.currentWorld.zombiesLayer.addChild(z);
				}
			}
		}
		
		public function destroy():void {
			GameTimer.instance.cancelCall(_callId);
		}
	}

}