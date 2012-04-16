package client
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	[Frame(factoryClass="client.Preloader")]
	public class Main extends Sprite 
	{

		private var _ingame:InGame;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_ingame = new InGame();
			addChild(_ingame);
		}

	}

}