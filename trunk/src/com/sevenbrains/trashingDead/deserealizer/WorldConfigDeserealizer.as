package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.definitions.WorldDefinition;
	import com.sevenbrains.trashingDead.definitions.WorldEntitiesDefinition;
	import com.sevenbrains.trashingDead.deserealizer.core.AbstractDeserealizer;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import flash.utils.Dictionary;
	
	/**
	* ...
	* @author Fulvio Crescenzi
	*/
	public class WorldConfigDeserealizer extends AbstractDeserealizer {
		
		private var _idsMap:Dictionary;
		
		public function WorldConfigDeserealizer(xml:XML) {
			super(xml);
		}
		
		override public function deserialize(xml:XML):void {
			_idsMap = new Dictionary();
			_map = new Dictionary();
			_map[ConfigNodes.WORLDS] = decodeWorlds(xml.worlds);
			_map[ConfigNodes.IDS] = _idsMap;
		}
		
		private function decodeWorlds(xml:XMLList):Array {
			var worlds:Array = [];
			for each (var element:XML in xml.elements()) {
				var trashes:Vector.<WorldEntitiesDefinition> = new Vector.<WorldEntitiesDefinition>();
				for each (var childT:XML in element.trashes.elements()) {
					trashes.push(new WorldEntitiesDefinition(childT.@code, childT.@weight));
				}
				var zombies:Vector.<WorldEntitiesDefinition> = new Vector.<WorldEntitiesDefinition>();
				for each (var childZ:XML in element.zombies.elements()) {
					zombies.push(new WorldEntitiesDefinition(childZ.@code, childZ.@weight));
				}
				var worldDef:WorldDefinition = new WorldDefinition(element.@id, element.@background, element.@soundId, element.@zombieMaxInScreen, element.@zombieTimeCreation, trashes, zombies);
				_idsMap[worldDef.id] = worldDef;
				worlds.push(worldDef);
			}
			return worlds;
		}
	}
}