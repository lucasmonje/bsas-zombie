package client.entities 
{
	import client.definitions.ItemDefinition;
	import client.interfaces.Collisionable;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Floor implements Collisionable 
	{
		private var _collisionId:String;
		private var _collisionAccept:Array;
		
		public function Floor(collisionId:String, collisionAccept:Array) 
		{
			_collisionId = collisionId;
			_collisionAccept = collisionAccept.concat();
		}
		
		/* INTERFACE client.interfaces.Collisionable */
		
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
		
	}

}