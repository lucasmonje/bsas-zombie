package com.sevenbrains.trashingDead.display 
{
	import com.sevenbrains.trashingDead.interfaces.Screenable;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.sevenbrains.trashingDead.enum.ClassStatesEnum;
	import com.sevenbrains.trashingDead.managers.AssetLoader;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class MapWorld extends Sprite implements Screenable 
	{
		private var _state:String;
		private var _data:String;
		
		private var _content:Sprite;
		
		private var _levels:Dictionary;
		
		public function MapWorld() 
		{
			super();
			
		}
		
		/* INTERFACE com.sevenbrains.trashingDead.interfaces.Screenable */
		
		public function get state():String 
		{
			return _state;
		}
		
		public function get data():String 
		{
			return _data;
		}
		
		public function destroy():void 
		{
			for each(var mc:MovieClip in _levels) {
				mc.removeEventListener(MouseEvent.CLICK, onLevelClick);
			}
			removeChild(_content);
			_content = null;
		}
		
		public function init():void 
		{
			_state = ClassStatesEnum.RUNNING;
			_data = "";
			
			var clazz:Class = ConfigModel.assets.getAssetDefinition(AssetsEnum.MAP_WORLD, 'mapWorld');
			_content = new clazz();
			addChild(_content);
			
			_levels = new Dictionary();
			var levelsAmount:int = ConfigModel.worlds.getWorlds().length;
			for (var i:int = 0; i < levelsAmount; i++) {
				var mc:MovieClip = _content['stage0' + (i+1).toString()];
				_levels[mc.name] = mc;
				mc.addEventListener(MouseEvent.CLICK, onLevelClick);
			}
		}
		
		private function onLevelClick(e:MouseEvent):void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			_data = mc.name;
			_state = ClassStatesEnum.DESTROYING;
		}
		
	}

}