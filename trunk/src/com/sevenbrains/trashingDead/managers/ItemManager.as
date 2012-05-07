package com.sevenbrains.trashingDead.managers 
{
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.entities.Item;
	import com.sevenbrains.trashingDead.entities.Trash;
	import com.sevenbrains.trashingDead.entities.Zombie;
	import com.sevenbrains.trashingDead.entities.FlyingZombie;
	import com.sevenbrains.trashingDead.factories.TrashFactory;
	import com.sevenbrains.trashingDead.interfaces.Destroyable;
	import com.sevenbrains.trashingDead.utils.DisplayUtil;
	import com.sevenbrains.trashingDead.utils.MathUtils;
	import flash.geom.Point;
	import com.sevenbrains.trashingDead.entities.Entity;
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemManager 
	{
		private var _itemList:Vector.<Entity>;
		private var _trashList:Vector.<Entity>;		
		private var _zombieList:Vector.<Entity>;
		
		private var _callId:int;
		
		public function ItemManager() {
			_itemList = new Vector.<Entity>();
			_trashList = new Vector.<Entity>();
			_zombieList = new Vector.<Entity>();
			
			_callId = GameTimer.instance.callMeEvery(1, update);
		}

		public function createItem(itemName:String, initialPosition:Point):Item {
			var itemDef:ItemDefinition = ConfigModel.entities.getWeaponByName(itemName);
			if (!itemDef) {
				throw new Error("No existe el item a arrojar");
			}
			var item:Item = new Item(itemDef, initialPosition);
			item.init();
			_itemList.push(item);
			return item;
		}		
		
		public function getTrashDefinition():ItemDefinition {
			var trashDef:ItemDefinition = TrashFactory.getTrashDefinition();
			_trashList.push(trash);
			return trash;
		}
		
		public function createZombie(props:ItemDefinition, initialPosition:Point):Entity {
			var zombieClass:Class = props.type == PhysicObjectType.FLYING_ZOMBIE ? FlyingZombie : Zombie;
			var zombie:Entity = new zombieClass(props, initialPosition);
			zombie.init();
			_zombieList.push(zombie);
			UserModel.instance.players.registZombie(zombie);
			return zombie;
		}
		
		public function getZombieAmount():uint {
			return _zombieList.length;
		}
		
		public function update():void {
			updateList(_itemList);
			updateList(_trashList);
			updateList(_zombieList);
		}
			
		private function updateList(list:Object):void {
			var i:int = 0;
			var item:Entity;
			while (i < list.length) {
				item = list[i];
				if (item.isDestroyed()) {
					item.destroy();
					item = null;
					list.splice(i, 1);
				}else {
					item.updatePosition();
					i++;
				}
			}
		}
		
		private function destroyList(list:Vector.<Entity>):void {
			for each(var entity:Entity in list) {
				entity.destroy();
			}
		}
		
		public function destroy():void {
			destroyList(_itemList);
			destroyList(_trashList);
			destroyList(_zombieList);
		
			GameTimer.instance.cancelCall(_callId);
		}
	}

}