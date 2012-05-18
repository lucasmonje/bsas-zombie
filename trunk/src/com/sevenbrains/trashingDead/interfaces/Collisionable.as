package com.sevenbrains.trashingDead.interfaces 
{
	import com.sevenbrains.trashingDead.definitions.EntityDefinition;
	
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
		function get collisionable():Boolean;
	}
	
}