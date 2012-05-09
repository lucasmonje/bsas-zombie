package com.sevenbrains.trashingDead.display 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.utils.StageReference;
	/**
	 * ...
	 * @author Fulvio
	 */
	public final class Loading extends Sprite 
	{
		private var _content:MovieClip;
		
		public function Loading() 
		{
			
		}
		
		public function init():void {
			var clazz:Class = ConfigModel.assets.getDefinition(AssetsEnum.COMMONS, "loader") as Class;
			_content = new clazz();
			
			var back:Sprite = new Sprite();
			back.graphics.beginFill(0);
			back.graphics.drawRect(0, 0, StageReference.stage.stageWidth, StageReference.stage.stageHeight);
			back.graphics.endFill();
			addChild(back);
			
			_content.x = StageReference.stage.stageWidth >> 1;
			_content.y = StageReference.stage.stageHeight >> 1;
			addChild(_content);
			_content.gotoAndPlay(1);
		}
		
		public function activate(value:Boolean):void {
			if (value) {
				_content.gotoAndPlay(1);
			}else{
				_content.stop();
			}
		}
	}

}