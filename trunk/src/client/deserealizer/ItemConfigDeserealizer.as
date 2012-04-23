package client.deserealizer 
{
	import client.definitions.ItemAffectingAreaDefinition;
	import client.definitions.ItemDefinition;
	import client.definitions.PhysicDefinition;
	import client.definitions.ItemPropertiesDefinition;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.xml.XMLNode;
	import client.ApplicationModel;
	import client.enum.ConfigNodes;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemConfigDeserealizer extends EventDispatcher
	{
		[Embed(source = '..\\resources\\xmls\\items-config.xml', mimeType = "application/octet-stream")]
		public var cXml:Class;
		
		private static var _instanciable:Boolean;
		private static var _instance:ItemConfigDeserealizer;
		
		public function ItemConfigDeserealizer() 
		{
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
		}
		
		public static function get instance():ItemConfigDeserealizer {
			if (!_instance) {
				_instanciable = true;
				_instance = new ItemConfigDeserealizer();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		public function init():void {
			var byteArray:ByteArray = new cXml() as ByteArray;
			var xml:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			
			decodeItems(ConfigNodes.TRASHES, xml.trashes);
			decodeItems(ConfigNodes.WEAPONS, xml.weapons);
			decodeItems(ConfigNodes.ZOMBIES, xml.zombies);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function decodeItems(key:String, xml:XMLList):void {
			var items:Array = [];
			
			for each(var element:XML in xml.elements()) {
				var physic:PhysicDefinition = new PhysicDefinition(element.physicProps.@density, element.physicProps.@friction, element.physicProps.@restitution);
				var props:ItemPropertiesDefinition = new ItemPropertiesDefinition(element.properties.@hits, element.properties.@life, element.properties.@collisionId, String(element.properties.@collisionAccept).split(","), element.properties.@speedMin, element.properties.@speedMax);
				var area:ItemAffectingAreaDefinition = new ItemAffectingAreaDefinition(element.affectingArea.@radius, element.affectingArea.@times, element.affectingArea.@hit);
				
				var itemDef:ItemDefinition = new ItemDefinition(element.@name, element.@code, element.@icon, element.@type, props, physic, area);
				
				items.push(itemDef);
			}
			
			ApplicationModel.instance.addMap(key, items);
		}
	}

}