package com.sevenbrains.trashingDead.entities 
{
	import Box2D.Common.Math.b2Vec2;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.enum.AssetsEnum;
	import com.sevenbrains.trashingDead.events.PlayerEvents;
	import com.sevenbrains.trashingDead.models.ConfigModel;
	import com.sevenbrains.trashingDead.models.WorldModel;
	import com.sevenbrains.trashingDead.utils.DisplayUtil;
	import com.sevenbrains.trashingDead.managers.GameTimer;
	import com.sevenbrains.trashingDead.factories.TrashFactory;
	import com.sevenbrains.trashingDead.managers.ItemManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio
	 */
	public final class Players extends Sprite 
	{
		private var _batter:Batter;
		private var _fatGuy:FatGuy;
		private var _girl:Girl;
		
		private var _content:MovieClip;
		
		private var _trashPosition:Point;
		private var _wagonPosition:Point;
		
		private var _currentTrash:Trash;
		
		private var _callId:int;
		
		public function Players() 
		{
			
		}
		
		public function init():void {
			var playersClass:Class = ConfigModel.assets.getDefinition(AssetsEnum.PLAYERS, "Asset") as Class;
			var _content:MovieClip = new playersClass();
			addChild(_content);
			
			var _worldModel:WorldModel = WorldModel.instance;
			_content.y = (_worldModel.floorRect.y * _worldModel.currentWorld.scaleY) - (_content.height * _worldModel.currentWorld.scaleY) - (_worldModel.floorRect.height * 3);
			
			// La posicion donde tiene q crearse la basura para el bateador
			var mcTrashPosition:MovieClip = _content.getChildByName("mcTrashPosition") as MovieClip;
			_trashPosition = new Point(mcTrashPosition.x + _content.x, mcTrashPosition.y + _content.y);
			DisplayUtil.remove(mcTrashPosition);
			
			// Posicion de la camioneta
			var mcWagonPosition:MovieClip = _content.getChildByName("mcWagonPosition") as MovieClip;
			_wagonPosition = new Point(mcWagonPosition.x, mcWagonPosition.y);
			
			// Assets de los players
			var batterContent:MovieClip = _content.getChildByName("mcPlayer_1") as MovieClip;
			var fatGuyContent:MovieClip = _content.getChildByName("mcPlayer_2") as MovieClip;
			var girlContent:MovieClip = _content.getChildByName("mcPlayer_3") as MovieClip;
			
			// Inicializacion de los players
			_batter = new Batter(null);
			_batter.init(batterContent, _content.getChildByName("mcPoweringContainer") as MovieClip);
			
			_fatGuy = new FatGuy();
			_fatGuy.init(fatGuyContent);
			
			_girl = new Girl();
			_girl.init(girlContent);
			
			// Listeners
			_batter.addEventListener(PlayerEvents.TRASH_HIT, batterThrewTrash);
			_fatGuy.addEventListener(PlayerEvents.THREW_TRASH, fatGuyThrewTrash);
			_fatGuy.addEventListener(PlayerEvents.DROP_TRASH, fatGuyDropTrash);
			
			_callId = GameTimer.instance.callMeEvery(1, update);
		}
		
		public function get wagonPosition():Point 
		{
			return _wagonPosition;
		}
		
		public function destroy():void {
			_batter.removeEventListener(PlayerEvents.TRASH_HIT, batterThrewTrash);
			_fatGuy.removeEventListener(PlayerEvents.THREW_TRASH, fatGuyThrewTrash);
			_fatGuy.removeEventListener(PlayerEvents.DROP_TRASH, fatGuyDropTrash);
			
			GameTimer.instance.cancelCall(_callId);
		}
		
		private function  update():void {
		}
		
		/**
		 * Bateador arrojó la basura. 
		 * Avisa al gordo que le de una nueva al bateador.
		 */
		private function batterThrewTrash(e:PlayerEvents):void {
			trashHit(Number(e.value1), Number(e.value2));
			_fatGuy.giveTrash();
		}
		
		/**
		 * El gordo le pasó la basura al bateador
		 */
		private function fatGuyThrewTrash(e:PlayerEvents):void {
			_fatGuy.prepareTrash();
		}
		
		 /**
		 * El gordo está listo para agarrar una nueva basura
		 */
		private function fatGuyDropTrash(e:PlayerEvents):void {
			createTrash(ItemDefinition(e.value1));
			_batter.readyToBat();
		}
		
		/**
		 * Crea la basura en base a la definicion que le paso el gordo
		 */
		private function createTrash(entityDef:ItemDefinition):void {
			_currentTrash = TrashFactory.instance.createTrash(entityDef, _trashPosition);
			ItemManager.instance.regist(_currentTrash);
			WorldModel.instance.currentWorld.playerLayer.addChild(_currentTrash);
		}
		
		/**
		 * El bateador golpea la basura
		 * @param	power
		 * @param	angle
		 */
		private function trashHit(power:Number, angle:Number):void {
			if (_currentTrash) {
				_currentTrash.shot(new b2Vec2((power * Math.cos(angle)) / 4, (power * Math.sin(angle)) / 4));
				WorldModel.instance.currentWorld.entityPathManager.regist(_currentTrash);
				_currentTrash = null;
			}
		}
		
	}

}