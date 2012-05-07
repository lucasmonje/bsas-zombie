package com.sevenbrains.trashingDead.deserealizer {
	import com.sevenbrains.trashingDead.deserealizer.core.AbstractDeserealizer;
	import com.sevenbrains.trashingDead.display.popup.nodes.*;
	import com.sevenbrains.trashingDead.display.popup.PopupProperties;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.exception.ASSERT;
	import com.sevenbrains.trashingDead.exception.InvalidArgumentException;
	import com.sevenbrains.trashingDead.utils.BooleanUtils;
	import com.sevenbrains.trashingDead.utils.ObjectUtil;
	import flash.utils.Dictionary;
	import flash.xml.XMLNode;
	import com.sevenbrains.trashingDead.display.popup.PopupChannel;
	
	public class PopupsConfigDeserealizer extends AbstractDeserealizer {
		
		private var _idsMap:Dictionary;
		
		public function PopupsConfigDeserealizer(source:String) {
			super(source);
		}
		
		override public function deserialize():void {
			_xml = new XML(_source);
			_map = new Dictionary();
			_idsMap = new Dictionary();
			var aliases:Dictionary = decodeAliases(_xml.aliases);
			_map[ConfigNodes.POPUPS] = decodePopups(_xml.popups, aliases);
			_map[ConfigNodes.IDS] = _idsMap;
		}
		
		private function decodeAliases(xml:XMLList):Dictionary {
			var aliases:Dictionary = new Dictionary();
			for each (var element:XML in xml.elements()) {
				var key:String = element.localName();
				var node:XML = element.elements()[0];
				aliases[key] = decodeNode(node);
			}
			return aliases;
		}
		
		private function decodePopups(xml:XMLList, aliases:Dictionary):Array {
			var popups:Array = [];
			for each (var popupConfig:XML in xml.elements()) {
				
				var id:String = popupConfig.@id;
				var assetId:String = popupConfig.@assetId;
				var i18n:String = popupConfig.@i18n.toString() != "" ? popupConfig.@i18n : assetId;
				var channel:String = popupConfig.@channel.toString() != "" ? popupConfig.@channel : "default";
				var popup:PopupProperties = new PopupProperties(assetId, i18n, channel);
				if (popupConfig.@template.toString() != "") {
					var template:PopupProperties = map[popupConfig.@template.toString()];
					ASSERT(template, 'template must be defined before popup');
					popup.append(template);
				}
				for each (var node:XML in popupConfig.elements()) {
					var name:String = node.localName();
					// Try to use alias and decode if not found
					if (name in aliases) {
						ASSERT(ObjectUtil.isEmpty(node.attributes()), 'Calls to aliases cannot specify attributes:' + name);
						popup.addNode(aliases[name]);
					} else {
						popup.addNode(decodeNode(node));
					}
				}
				_idsMap[id] = popup;
				popups.push(popup);
				
			}
			return popups;
		}
		
		private function decodeNode(node:XML):IPopupNode {
			var type:String = node.localName();
			var path:String, key:String, url:String, handler:String, args:String = new String();
			path = node.@path.toString();
			key = node.@key.toString();
			url = node.@url.toString();
			args = node.@args.toString();
			handler = node.@handler.toString();
			
			switch (type) {
				case 'text':
					ASSERT(path && key);
					return new PopupI18nNode(path, key, args);
				case 'image': 
					ASSERT(path && url);
					return new PopupImageNode(path, url, args);
				case 'button': 
					ASSERT(path && handler);
					return new PopupButtonNode(path, handler, args);
				case 'hide': 
					ASSERT(path);
					return new PopupHideNode(path);
				case 'keyboard': 
					ASSERT(key);
					var code:uint = PopupKeyboardNode.getCode(key);
					ASSERT(code && handler);
					return new PopupKeyboardNode(code, handler, args);
				case 'state': 
					var name:String = node.@name;
					ASSERT(name);
					var play:Boolean = BooleanUtils.fromString(node.@play, false);
					return new PopupStateNode(path, name, play);
				case 'property': 
					ASSERT(key);
					var value:Object = node.@value;
					return new PopupPropertyNode(key, value);
				default: 
					throw new InvalidArgumentException(this + 'Unexpected popup child node: ' + type);
			}
		}
	}
}