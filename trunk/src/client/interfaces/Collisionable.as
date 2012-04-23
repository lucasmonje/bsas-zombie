package client.interfaces 
{
	import client.definitions.ItemDefinition;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public interface Collisionable 
	{
		function collide(who:Collisionable):void;
		function isCollisioning(who:Collisionable):Boolean;
		function getCollisionId():String;
		function getCollisionAccept():Array;
	}
	
}