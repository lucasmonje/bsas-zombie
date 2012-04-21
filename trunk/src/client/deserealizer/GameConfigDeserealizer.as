package client.deserealizer 
{
	import client.definitions.ItemAffectingAreaDefinition;
	import client.definitions.ItemDefinition;
	import client.definitions.ItemPropertiesDefinition;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.xml.XMLNode;
	import client.ApplicationModel;
	import client.ConfigNodes;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class GameConfigDeserealizer extends EventDispatcher
	{
		[Embed(source = '..\\resources\\xmls\\game-config.xml', mimeType = "application/octet-stream")]
		public var cXml:Class;
		
		private static var _instanciable:Boolean;
		private static var _instance:GameConfigDeserealizer;
		
		public function GameConfigDeserealizer() 
		{
			if (!_instanciable) {
				throw new Error("It is a singleton class");
			}
		}
		
		public static function get instance():GameConfigDeserealizer {
			if (!_instance) {
				_instanciable = true;
				_instance = new GameConfigDeserealizer();
				_instanciable = false;
			}
			
			return _instance;
		}
		
		public function init():void {
			var byteArray:ByteArray = new cXml() as ByteArray;
			var xml:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			
			for each(var element:XML in xml.elements()) {
				var playerXml:XML = element.player;
				for each (var playerElement:XML in playerXml) {
					
				}
			}
			
			ApplicationModel.instance.addMap(ConfigNodes.ITEMS, items);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}

}