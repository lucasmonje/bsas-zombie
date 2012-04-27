package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import com.sevenbrains.trashingDead.interfaces.Collisionable;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Floor implements Collisionable 
	{
		private var _collisionId:String;
		private var _collisionAccept:Array;
		private var _type:String;
		
		public function Floor(collisionId:String, collisionAccept:Array, type:String) 
		{
			_collisionId = collisionId;
			_collisionAccept = collisionAccept.concat();
			_type =  type;
		}
		
		/* INTERFACE interfaces.Collisionable */
		
		public function collide(who:Collisionable):void 
		{
			
		}
		
		public function isCollisioning(who:Collisionable):Boolean 
		{
			return getCollisionAccept().indexOf(who.getCollisionId()) > -1;
		}
		
		public function getCollisionId():String 
		{
			return _collisionId;
		}
		
		public function getCollisionAccept():Array 
		{
			return _collisionAccept.concat();
		}
				
		public function get type():String 
		{
			return _type;
		}
		
		
	}

}