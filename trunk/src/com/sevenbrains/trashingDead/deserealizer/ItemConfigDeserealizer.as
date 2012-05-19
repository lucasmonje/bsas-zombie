package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.definitions.AnimationDefinition;
	import com.sevenbrains.trashingDead.definitions.CollisionDefinition;
	import com.sevenbrains.trashingDead.definitions.DamageAreaDefinition;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.definitions.PhysicDefinition;
	import com.sevenbrains.trashingDead.deserealizer.core.AbstractDeserealizer;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.utils.BooleanUtils;
	
	import flash.utils.Dictionary;
	
	public class ItemConfigDeserealizer extends AbstractDeserealizer {
		
		private var _idsMap:Dictionary;
		
		public function ItemConfigDeserealizer(source:String) {
			super(source);
		}
		
		override public function deserialize():void {
			_xml = new XML(_source);
			_idsMap = new Dictionary();
			_map = new Dictionary();
			_map[ConfigNodes.TRASHES] = decodeItems(_xml.trashes);
			_map[ConfigNodes.WEAPONS] = decodeItems(_xml.weapons);
			_map[ConfigNodes.ZOMBIES] = decodeItems(_xml.zombies);
			_map[ConfigNodes.STUFFS] = decodeItems(_xml.stuffs);
			_map[ConfigNodes.IDS] = _idsMap;
		}
		
		private function decodeItems(xml:XMLList):Array {
			var items:Array = [];
			for each (var element:XML in xml.elements()) {
				var physic:PhysicDefinition = getPhysicDef(element.physicProps);
				var collision:CollisionDefinition = getCollisionDef(element.collision);
				var area:DamageAreaDefinition = getDamageAreaDef(element.damageArea);
				var animations:Vector.<AnimationDefinition> = getAnimationsDef(element.animations);
				var itemDef:ItemDefinition = new ItemDefinition(element.@name, element.@code, element.@icon, element.@type, collision, physic, area, animations);
				items.push(itemDef);
				_idsMap[itemDef.code] = itemDef;
			}
			return items;
		}
		
		private function getPhysicDef(node:XMLList):PhysicDefinition {
			if (!Boolean(node.length())) return null;
			return new PhysicDefinition(node.@density, node.@friction, node.@restitution);
		}
		
		private function getCollisionDef(node:XMLList):CollisionDefinition {
			if (!Boolean(node.length())) return null;
			return new CollisionDefinition(node.@hits, node.@life, node.@collisionId, node.@collisionAccept.toString().split(","), node.@speedMin, node.@speedMax);
		}

		private function getDamageAreaDef(node:XMLList):DamageAreaDefinition {
			if (!Boolean(node.length())) return null;
			return new DamageAreaDefinition(node.@radius, node.@time, node.@hit);
		}

		private function getAnimationsDef(node:XMLList):Vector.<AnimationDefinition> {
			if (!Boolean(node.length())) return null;
			var animations:Vector.<AnimationDefinition> = new Vector.<AnimationDefinition>();
			for each (var child:XML in node.elements()){
				animations.push(new AnimationDefinition(child.@name, child.@frameTime, child.@afterReproduce, BooleanUtils.fromString(child.@defaultAnim)));
			}
			return animations;
		}
	}
}