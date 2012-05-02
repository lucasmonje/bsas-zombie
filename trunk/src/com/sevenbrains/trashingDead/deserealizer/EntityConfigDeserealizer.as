package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.definitions.ItemDamageAreaDefinition;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.definitions.ItemPropertiesDefinition;
	import com.sevenbrains.trashingDead.definitions.PhysicDefinition;
	import com.sevenbrains.trashingDead.deserealizer.core.AbstractDeserealizer;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import flash.utils.Dictionary;
	
	public class EntityConfigDeserealizer extends AbstractDeserealizer {
		
		public function EntityConfigDeserealizer(xml:XML) {
			super(xml);
		}
		
		override public function deserialize(xml:XML):void {
			_map = new Dictionary();
			_map[ConfigNodes.TRASHES] = decodeItems(xml.trashes);
			_map[ConfigNodes.WEAPONS] = decodeItems(xml.weapons);
			_map[ConfigNodes.ZOMBIES] = decodeItems(xml.zombies);
		}
		
		private function decodeItems(xml:XMLList):Array {
			var items:Array = [];
			for each (var element:XML in xml.elements()) {
				var physic:PhysicDefinition = new PhysicDefinition(element.physicProps.@density, element.physicProps.@friction, element.physicProps.@restitution);
				var props:ItemPropertiesDefinition = new ItemPropertiesDefinition(element.properties.@hits, element.properties.@life, element.properties.@collisionId, String(element.properties.@collisionAccept).split(","), element.properties.@speedMin, element.properties.@speedMax);
				var area:ItemDamageAreaDefinition = new ItemDamageAreaDefinition(element.damageArea.@radius, element.damageArea.@times, element.damageArea.@hit);
				var itemDef:ItemDefinition = new ItemDefinition(element.@name, element.@code, element.@icon, element.@type, props, physic, area);
				items.push(itemDef);
			}
			return items;
		}
	}
}