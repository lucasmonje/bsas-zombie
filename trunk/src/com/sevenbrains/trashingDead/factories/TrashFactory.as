package com.sevenbrains.trashingDead.factories 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.entities.Trash;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.utils.MathUtils;
	/**
	 * ...
	 * @author Fulvio
	 */
	public class TrashFactory 
	{
		private static var _instance:TrashFactory;
		private static var _instanciable:Boolean;
		
		public static function get instance():TrashFactory {
			if (!_instance) {
				_instanciable = true;
				_instance = new TrashFactory();
				_instanciable = false;
			}			
			return _instance;
		}
		
		public function TrashFactory() 
		{
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
		}
		
		public function getTrashDefinition():ItemDefinition {
			var entities:Array = ConfigModel.entities.getTrashes().concat();
			return entities[MathUtils.getRandomInt(1, entities.length) - 1];
		}
		
		public function createTrash():Trash {
			var trashDef:ItemDefinition = getTrashDefinition();
			
			var trash:Trash = new Trash(trashDef);
			trash.init();
			return trash;
		}
		
		public function createTrashFromDefinition(def:ItemDefinition):Trash {
			var trash:Trash = new Trash(trashDef);
			trash.init();
			return trash;
		}
	}

}