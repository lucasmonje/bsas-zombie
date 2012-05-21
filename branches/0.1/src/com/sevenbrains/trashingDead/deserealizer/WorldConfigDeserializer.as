package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.definitions.WorldDefinition;
	import com.sevenbrains.trashingDead.definitions.WorldEntitiesDefinition;
	import com.sevenbrains.trashingDead.deserealizer.core.BuilderDeserealizer;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.interfaces.Buildable;
	
	import flash.utils.Dictionary;
	
	/**
	* ...
	* @author Fulvio Crescenzi
	*/
	public class WorldConfigDeserializer extends BuilderDeserealizer implements Buildable {
		
		public static const TYPE:String = "worldConfigDeserializer";
		
		private var _idsMap:Dictionary;
		
		public function WorldConfigDeserializer(source:String) {
			super(source);
		}
		
		override public function deserialize(source:String):* {
			_xml = new XML(source);
			_idsMap = new Dictionary();
			_map = new Dictionary();
			_map[ConfigNodes.WORLDS] = decodeWorlds(_xml.worlds);
			_map[ConfigNodes.IDS] = _idsMap;
			return _map;
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
				var worldDef:WorldDefinition = new WorldDefinition(element.@id, element.@background, element.@soundId, element.@zombieMaxInScreen, element.@zombieTimeCreation, element.@stageTime, trashes, zombies);
				_idsMap[worldDef.id] = worldDef;
				worlds.push(worldDef);
			}
			return worlds;
		}
	}
}