package com.sevenbrains.trashingDead.display 
{
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.enum.ClassStatesEnum;
	import com.sevenbrains.trashingDead.interfaces.Screenable;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class MainMenu extends Sprite implements Screenable
	{
		private var _content:Sprite;
		private var _btnPlay:MovieClip;
		private var _state:String;
		private var _data:String;
		
		public function MainMenu() 
		{
			super();
		}
		
		public function init():void {
			var clazz:Class = ConfigModel.assets.getDefinition(AssetsEnum.GAME_TITLE, 'gameTitle');
			_content = new clazz();
			addChild(_content);
			
			_btnPlay = _content["btnPlay"] as MovieClip;
			_btnPlay.addEventListener(MouseEvent.CLICK, onPlay);
			
			_state = ClassStatesEnum.RUNNING;
		}
		
		private function onPlay(e:MouseEvent):void {
			_state = ClassStatesEnum.DESTROYING;
		}
		
		public function destroy():void {
			removeChild(_content);
			_content = null;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function get data():String 
		{
			return _data;
		}
	}

}