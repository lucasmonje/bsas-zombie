//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.deserealizer {
	
	import com.sevenbrains.trashingDead.definitions.SuggestionDefinition;
	import com.sevenbrains.trashingDead.deserealizer.core.AbstractDeserealizer;
	import com.sevenbrains.trashingDead.enum.ConfigNodes;
	import com.sevenbrains.trashingDead.exception.DuplicateIdException;
	import com.sevenbrains.trashingDead.utils.BooleanUtils;
	import com.sevenbrains.trashingDead.utils.ClassUtil;
	import flash.utils.Dictionary;
	
	public class SuggestionConfigDeserializer extends AbstractDeserealizer {
		
		private var _groupIdsMap:Dictionary;
		
		private var _idsMap:Dictionary;
		
		private var _prefixPath:String;
		
		public function SuggestionConfigDeserializer(source:String) {
			super(source);
		}
		
		override public function deserialize():void {
			_xml = new XML(_source);
			_groupIdsMap = new Dictionary();
			_idsMap = new Dictionary();
			_map = new Dictionary();
			_map[ConfigNodes.SUGGESTIONS] = deserializeSuggestions(_xml.children());
			_map[ConfigNodes.GROUP_IDS] = _groupIdsMap;
			_map[ConfigNodes.IDS] = _idsMap;
		}
		
		private function deserializeSuggestion(node:XML):SuggestionDefinition {
			var suggDef:SuggestionDefinition = new SuggestionDefinition();
			var lockDeserializer:LockDeserializer = new LockDeserializer(node);
			var executeDeserializer:ExecuteDeserializer = new ExecuteDeserializer(node);
			suggDef.name = node.@name.toString();
			suggDef.id = node.@id.toString();
			suggDef.persist = BooleanUtils.fromString(node.@persist.toString());
			suggDef.url = _prefixPath + node.@name.toString() + '.swf';
			suggDef.lock = lockDeserializer.deserialize();
			suggDef.execute = executeDeserializer.deserialize();
			return suggDef;
		}
		
		private function deserializeSuggestions(suggGroupsXML:XMLList):Vector.<SuggestionDefinition> {
			var list:Vector.<SuggestionDefinition> = new Vector.<SuggestionDefinition>();
			
			for each (var suggGroup:XML in suggGroupsXML) {
				_prefixPath = suggGroup.@iconPath.toString();
				
				for each (var suggNode:XML in suggGroup.elements()) {
					var suggDef:SuggestionDefinition = deserializeSuggestion(suggNode);
					
					if (Boolean(_idsMap[suggDef.id])) {
						throw new DuplicateIdException(ClassUtil.getName(this) + " > " + suggDef.id);
					}
					_idsMap[suggDef.id] = suggDef;
					list.push(suggDef);
				}
				_groupIdsMap[suggGroup.localName()] = list;
			}
			return list;
		}
	}
}