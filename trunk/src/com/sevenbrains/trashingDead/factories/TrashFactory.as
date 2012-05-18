package com.sevenbrains.trashingDead.factories 
{
	import com.sevenbrains.trashingDead.definitions.EntityDefinition;
	import com.sevenbrains.trashingDead.entities.Trash;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.utils.MathUtils;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio
	 */
	public class TrashFactory 
	{
		private static var _instance:TrashFactory=null;
		private static var _instanciable:Boolean=false;
		
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
		
		public function createTrash(def:EntityDefinition, pos:Point):Trash {
			var trash:Trash = new Trash(def, pos);
			trash.init();
			return trash;
		}
	}

}