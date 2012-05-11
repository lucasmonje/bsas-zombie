package com.sevenbrains.trashingDead.definitions 
{
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class WorldDefinition 
	{
		private var _id:String;
		private var _background:String;
		private var _soundId:String;
		private var _zombieMaxInScreen:uint;
		private var _zombieTimeCreation:Number;
		private var _stageTime:int;
		
		private var _trashes:Vector.<WorldEntitiesDefinition>;
		private var _zombies:Vector.<WorldEntitiesDefinition>;
		
		public function WorldDefinition(id:String, background:String, soundId:String, zombieMaxInScreen:uint, zombieTimeCreation:Number, stageTime:Number, trashes:Vector.<WorldEntitiesDefinition>, zombies:Vector.<WorldEntitiesDefinition>) 
		{
			_id = id;
			_background = background;
			_soundId = soundId;
			_zombieMaxInScreen = zombieMaxInScreen;
			_zombieTimeCreation = zombieTimeCreation;
			_stageTime = int(stageTime);
			_trashes = trashes.concat();
			_zombies = zombies.concat();
		}
		
		public function get stageTime():int
		{
			return _stageTime;
		}

		public function get id():String 
		{
			return _id;
		}
		
		public function get background():String 
		{
			return _background;
		}
		
		public function get soundId():String 
		{
			return _soundId;
		}
		
		public function get zombieMaxInScreen():uint 
		{
			return _zombieMaxInScreen;
		}
		
		public function get zombieTimeCreation():Number 
		{
			return _zombieTimeCreation;
		}
		
		public function get trashes():Vector.<WorldEntitiesDefinition> 
		{
			return _trashes.concat();
		}
		
		public function get zombies():Vector.<WorldEntitiesDefinition> 
		{
			return _zombies.concat();
		}
	}

}