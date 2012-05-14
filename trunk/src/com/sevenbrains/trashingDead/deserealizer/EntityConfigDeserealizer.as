package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.definitions.ItemAnimationsDefinition;
	import com.sevenbrains.trashingDead.definitions.ItemDamageAreaDefinition;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.definitions.ItemPropertiesDefinition;
	import com.sevenbrains.trashingDead.definitions.PhysicDefinition;
	import com.sevenbrains.trashingDead.deserealizer.core.AbstractDeserealizer;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.utils.BooleanUtils;
	import flash.utils.Dictionary;
	
	public class EntityConfigDeserealizer extends AbstractDeserealizer {
		
		public function EntityConfigDeserealizer(source:String) {
			super(source);
		}
		
		override public function deserialize():void {
			_xml = new XML(_source);
			_map = new Dictionary();
			_map[ConfigNodes.TRASHES] = decodeItems(_xml.trashes);
			_map[ConfigNodes.WEAPONS] = decodeItems(_xml.weapons);
			_map[ConfigNodes.ZOMBIES] = decodeItems(_xml.zombies);
			_map[ConfigNodes.STUFFS] = decodeItems(_xml.stuffs);
		}
		
		private function decodeItems(xml:XMLList):Array {
			var items:Array = [];
			for each (var element:XML in xml.elements()) {
				var physic:PhysicDefinition = new PhysicDefinition(element.physicProps.@density, element.physicProps.@friction, element.physicProps.@restitution);
				var props:ItemPropertiesDefinition = new ItemPropertiesDefinition(element.properties.@hits, element.properties.@life, element.properties.@collisionId, String(element.properties.@collisionAccept).split(","), element.properties.@speedMin, element.properties.@speedMax);
				var area:ItemDamageAreaDefinition = new ItemDamageAreaDefinition(element.damageArea.@radius, element.damageArea.@times, element.damageArea.@hit);
				
				var animations:Vector.<ItemAnimationsDefinition> = new Vector.<ItemAnimationsDefinition>();
				for each (var child:XML in element.animations.elements()){
					animations.push(new ItemAnimationsDefinition(child.@name, child.@frameTime, child.@afterReproduce, BooleanUtils.fromString(child.@defaultAnim)));
				}
				
				var itemDef:ItemDefinition = new ItemDefinition(element.@name, element.@code, element.@icon, element.@type, props, physic, area, animations);
				items.push(itemDef);
			}
			return items;
		}
	}
}