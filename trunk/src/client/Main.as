package client
{
	import flash.display.Sprite;
	import flash.events.Event;
	import client.deserealizer.ItemConfigDeserealizer;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	[SWF(width = "835", height = "550", frameRate = "30", backgroundColor = "#234a00")]
	[Frame(factoryClass="client.Preloader")]
	public class Main extends Sprite 
	{

		private var _ingame:InGame;
		
		private var _resources:int;
		private var _loaded:int;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_resources = 2;
			_loaded = 0;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			ItemConfigDeserealizer.instance.addEventListener(Event.COMPLETE, onItemConfigLoaded);
			ItemConfigDeserealizer.instance.init();
			
			AssetLoader.instance.addEventListener(Event.COMPLETE, onAssetLoaded);
			AssetLoader.instance.init();
			
		}
		
		private function onItemConfigLoaded(e:Event):void {
			ItemConfigDeserealizer.instance.removeEventListener(Event.COMPLETE, onItemConfigLoaded);
			
			begin();
		}
		
		private function onAssetLoaded(e:Event):void {
			AssetLoader.instance.removeEventListener(Event.COMPLETE, onAssetLoaded);
			
			begin();
		}
		
		private function begin():void {
			if (++_loaded == _resources) {
				ApplicationModel.instance.stage = stage;
				
				_ingame = new InGame();
				addChild(_ingame);
			}
		}

	}

}