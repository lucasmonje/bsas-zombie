package {
	
	import com.adobe.cairngorm.model.ModelLocator;
	import com.sevenbrains.trashingDead.controller.ApplicationController;
	import com.sevenbrains.trashingDead.display.InGame;
	import com.sevenbrains.trashingDead.display.MainMenu;
	import com.sevenbrains.trashingDead.enum.ClassStatesEnum;
	import com.sevenbrains.trashingDead.interfaces.IConfigBuilder;
	import com.sevenbrains.trashingDead.interfaces.Screenable;
	import com.sevenbrains.trashingDead.managers.FullscreenManager;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.models.UserModel;
	import com.sevenbrains.trashingDead.utils.CheatCentral;
	import com.sevenbrains.trashingDead.utils.StageReference;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	* ...
	* @author Fulvio Crescenzi
	*/
	[SWF(pageTitle="Trashing Dead", width="900",height="550",frameRate="30",backgroundColor="#000000")]
	[Frame(factoryClass="com.sevenbrains.trashingDead.display.Preloader")]
	
	public class Main extends Sprite {
		
		private var _mainMenu:MainMenu;
		private var _ingame:InGame;
		private var _resources:int;
		private var _loaded:int;
		private var _actualScreen:String;
		private var _map:Dictionary;
		private var _appController:ApplicationController;
		private var _cheats:CheatCentral;
		
		public function Main():void {
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event=null):void {
			Manifest;
			_appController = new ApplicationController();
			StageReference.initReference(stage);
			GameTimer.instance.start();
			UserModel.instance;
			FullscreenManager.instance.root = this;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			loadConfig();
			_cheats = new CheatCentral();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKpressed);
		}
		
		private function loadConfig():void {
			_loaded = 0;
			_resources = 0;
			var byteArray:ByteArray = new EmbedAsset.xmlGameConfigClass() as ByteArray;
			var xml:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			var configList:XMLList = xml.preloaderProccess.config;
			for each (var config:XML in configList) {
				_resources++;
				var builder:String = config.@builder.toString();
				var builderClass:Class = getDefinitionByName(builder) as Class;
				var configBuilder:IConfigBuilder = new builderClass() as IConfigBuilder;
				for each (var param:XML in config.param) {
					var name:String = param.@name.toString();
					var value:String = param.@value.toString();
					configBuilder[name] = value; 
				}
				configBuilder.addEventListener(Event.COMPLETE, configBuilderCompleted);
				configBuilder.build();
			}
		}
		
		private function configBuilderCompleted(e:Event):void {
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
		
		private function onKpressed(e:KeyboardEvent):void {
			_cheats.cheat(String.fromCharCode(e.charCode), e.ctrlKey, e.altKey, e.shiftKey);
		}
	}
}