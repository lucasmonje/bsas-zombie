package com.sevenbrains.trashingDead.deserealizer 
{
	import adobe.utils.CustomActions;
	import com.sevenbrains.trashingDead.definitions.WorldDefinition;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.models.ApplicationModel;
	import com.sevenbrains.trashingDead.definitions.WorldEntitiesDefinition;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class WorldConfigDeserealizer extends EventDispatcher
	{
		[Embed(source = '..\\..\\..\\..\\..\\resources\\worlds-config.xml', mimeType = "application/octet-stream")]
		private var cXml:Class;
		
		private static var _instanciable:Boolean;
		private static var _instance:WorldConfigDeserealizer;
		
		public function WorldConfigDeserealizer() 
		{
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
		}
		
		public static function get instance():WorldConfigDeserealizer {
			if (!_instance) {
				_instanciable = true;
				_instance = new WorldConfigDeserealizer();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		public function init():void {
			var byteArray:ByteArray = new cXml() as ByteArray;
			var xml:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			
			decodeWorlds(ConfigNodes.WORLDS, xml.worlds)
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function decodeWorlds(key:String, xml:XMLList):void {
			var worlds:Array = [];
			
			for each(var element:XML in xml.elements()) {
				
				var trashes:Vector.<WorldEntitiesDefinition> = new Vector.<WorldEntitiesDefinition>();
				for each (var childT:XML in element.trashes.elements()) {
					trashes.push(new WorldEntitiesDefinition(childT.@code, childT.@weight));
				}
				
				var zombies:Vector.<WorldEntitiesDefinition> = new Vector.<WorldEntitiesDefinition>();
				for each (var childZ:XML in element.zombies.elements()) {
					zombies.push(new WorldEntitiesDefinition(childZ.@code, childZ.@weight));
				}
				
				var worldDef:WorldDefinition = new WorldDefinition(element.@id, element.@background, element.@zombieMaxInScreen, element.@zombieTimeCreation, trashes, zombies);
				
				worlds.push(worldDef);
			}
			
			ApplicationModel.instance.addMap(key, worlds);
		}
	}

}