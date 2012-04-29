package 
{
	import adobe.utils.CustomActions;
	import com.sevenbrains.trashingDead.display.MainMenu;
	import com.sevenbrains.trashingDead.interfaces.Screenable;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.sevenbrains.trashingDead.deserealizer.ItemConfigDeserealizer;
	import com.sevenbrains.trashingDead.deserealizer.WorldConfigDeserealizer;
	import com.sevenbrains.trashingDead.managers.FullscreenManager;
	import com.sevenbrains.trashingDead.utils.StageReference;
	import com.sevenbrains.trashingDead.managers.AssetLoader;
	import com.sevenbrains.trashingDead.display.InGame;
	import flash.utils.Dictionary;
	import com.sevenbrains.trashingDead.enum.ClassStatesEnum;

	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	[SWF(width = "900", height = "500", frameRate = "30", backgroundColor = "#234a00")]
	[Frame(factoryClass="com.sevenbrains.trashingDead.display.Preloader")]
	public class Main extends Sprite 
	{
		private var _mainMenu:MainMenu;
		private var _ingame:InGame;
		
		private var _resources:int;
		private var _loaded:int;
		
		private var _actualScreen:String;
		private var _map:Dictionary;
		
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
				
				addEventListener(Event.ENTER_FRAME, update);
				
				_mainMenu = new MainMenu();
				_mainMenu.init();
				addChild(_mainMenu);
				
				_ingame = new InGame();
				
				_map = new Dictionary();
				_map['mainMenu'] = new Dictionary();
				_map['mainMenu']['actual'] = _mainMenu;
				_map['mainMenu'][ClassStatesEnum.DESTROYING] = 'ingame';
				
				_map['ingame'] = new Dictionary();
				_map['ingame']['actual'] = _ingame;
				_map['ingame'][ClassStatesEnum.DESTROYING] = 'mainMenu';
				
				_actualScreen = 'mainMenu';
			}
		}
		
		private function update(e:Event):void {
			var screen:Screenable = _map[_actualScreen]['actual'];
			if (screen.state == ClassStatesEnum.DESTROYING) {
				_actualScreen = _map[_actualScreen][screen.state];
				removeChild(Sprite(screen));
				screen.destroy();
				screen = _map[_actualScreen]['actual'];
				screen.init();
				addChild(Sprite(screen));
			}
		}

	}

}