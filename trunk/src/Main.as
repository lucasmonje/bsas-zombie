package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import com.sevenbrains.trashingDead.deserealizer.ItemConfigDeserealizer;
	import com.sevenbrains.trashingDead.deserealizer.WorldConfigDeserealizer;
	import com.sevenbrains.trashingDead.managers.FullscreenManager;
	import com.sevenbrains.trashingDead.utils.StageReference;
	import com.sevenbrains.trashingDead.managers.AssetLoader;
	import com.sevenbrains.trashingDead.display.InGame;

	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	[SWF(width = "1000", height = "600", frameRate = "30", backgroundColor = "#234a00")]
	[Frame(factoryClass="com.sevenbrains.trashingDead.display.Preloader")]
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
			StageReference.initReference(stage);
			FullscreenManager.instance.root = this;
			_resources = 3;
			_loaded = 0;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			ItemConfigDeserealizer.instance.addEventListener(Event.COMPLETE, onItemsConfigLoaded);
			ItemConfigDeserealizer.instance.init();
			
			WorldConfigDeserealizer.instance.addEventListener(Event.COMPLETE, onWorldsConfigLoaded);
			WorldConfigDeserealizer.instance.init();
			
			AssetLoader.instance.addEventListener(Event.COMPLETE, onAssetLoaded);
			AssetLoader.instance.init();
			
		}
		
		private function onItemsConfigLoaded(e:Event):void {
			ItemConfigDeserealizer.instance.removeEventListener(Event.COMPLETE, onItemsConfigLoaded);
			
			begin();
		}
		
		private function onWorldsConfigLoaded(e:Event):void {
			WorldConfigDeserealizer.instance.removeEventListener(Event.COMPLETE, onWorldsConfigLoaded);
			
			begin();
		}
		
		private function onAssetLoaded(e:Event):void {
			AssetLoader.instance.removeEventListener(Event.COMPLETE, onAssetLoaded);
			
			begin();
		}
		
		private function begin():void {
			if (++_loaded == _resources) {
				_ingame = new InGame();
				addChild(_ingame);
			}
		}

	}

}