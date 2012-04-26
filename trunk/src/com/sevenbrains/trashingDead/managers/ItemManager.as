package com.sevenbrains.trashingDead.managers 
{
	import com.sevenbrains.trashingDead.definitions.GameProperties;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.entities.Item;
	import com.sevenbrains.trashingDead.entities.Trash;
	import com.sevenbrains.trashingDead.entities.Zombie;
	import com.sevenbrains.trashingDead.interfaces.Destroyable;
	import com.sevenbrains.trashingDead.models.ApplicationModel;
	import com.sevenbrains.trashingDead.utils.DisplayUtil;
	import com.sevenbrains.trashingDead.utils.MathUtils;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemManager 
	{
		private var _itemList:Vector.<Trash>;
		private var _trashList:Vector.<Trash>;		
		private var _zombieList:Vector.<Zombie>;	
		
		public function ItemManager() {
			_itemList = new Vector.<Trash>();
			_trashList = new Vector.<Trash>();
			_zombieList = new Vector.<Zombie>();
		}

		public function createItem(itemName:String, initialPosition:Point):Item {
			var itemDef:ItemDefinition = ApplicationModel.instance.getWeaponByName(itemName);
			if (!itemDef) {
				throw new Error("No existe el item a arrojar");
			}
			var item:Item = new Item(itemDef, initialPosition);
			item.init();
			_trashList.push(item);
			return item;
		}		
		
		public function createRandomTrash(initialPosition:Point):Trash {
			var itemDef:ItemDefinition = getTrash();
			var trash:Trash = new Trash(itemDef, initialPosition);
			trash.init();
			_trashList.push(trash);
			return trash;
		}
		
		private function getTrash():ItemDefinition {
			var items:Array = ApplicationModel.instance.getTrashes().concat();
			return items[MathUtils.getRandomInt(1, items.length) - 1];
		}
		
		public function createZombie(initialPosition:Point):Zombie {
			var zombie:Zombie;
			if (_zombieList.length < GameProperties.MAX_ZOMBIES_IN_SCREEN) {
				var itemDef:ItemDefinition = ApplicationModel.instance.getZombies()[0];
				zombie = new Zombie(itemDef, initialPosition);
				zombie.init();
				_zombieList.push(zombie);				
			}
			return zombie;
		}
		
		public function destroyZombie(zombie:Zombie):void {
			if (!zombie) {
				return;
			}
			DisplayUtil.remove(zombie);
			var i:int = _zombieList.indexOf(zombie);
			if (i > -1) {
				_zombieList.splice(i, 1);
			}
			zombie.destroy();
		}
		
		public function update():void {
			updateList(_itemList);
			updateList(_trashList);
			updateList(_zombieList);
		}
			
		private function updateList(list:Object):void {
			var i:int = 0;
			var item:Destroyable;
			while (i < list.length) {
				item = list[i];
				if (item.isDestroyed()) {
					item.destroy();
					item = null;
					list.splice(i, 1);
				}else {
					i++;
				}
			}
		}
	}

}