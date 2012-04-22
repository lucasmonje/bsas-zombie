package client.managers 
{
	import Box2D.Dynamics.b2World;
	import client.definitions.ItemDefinition;
	import client.entities.Trash;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemManager 
	{
		private var _world:b2World;
		private var _worldScale:int;
		private var _items:Vector.<Trash>;
		
		public function ItemManager(world:b2World, worldScale:int) 
		{
			_items = new Vector.<Trash>();
			_world = world;
			_worldScale = worldScale;
		}
		
		
		public function add(itemDef:ItemDefinition, position:Point):Trash {
			var item:Trash;
			if (itemDef.type == 'handable') {
				item = createItem(itemDef, position);
			}
			
			return item;
		}
		
		private function createTrash(itemDef:ItemDefinition, position:Point):Trash {
			return null;
		}
		
		private function createItem(itemDef:ItemDefinition, position:Point):Trash {
			if (!itemDef) {
				throw new Error("No existe el item a arrojar");
			}
			
			var item:Trash = new Trash(itemDef, position);
			item.init(_world, _worldScale);
			
			return item;
		}
	}

}