package client.b2 
{
	import client.definitions.PhysicDefinition;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public interface PhysicInformable 
	{
		function get initialStageBounds():Rectangle;
		function set initialStageBounds(value:Rectangle):void;
		function get initialWorldBounds():Rectangle;
		function set initialWorldBounds(value:Rectangle):void;
		function get isDynamic():Boolean;
		function set isDynamic(value:Boolean):void;
		function get physicProps():PhysicDefinition;
		function set physicProps(value:PhysicDefinition):void;
		function get userData():Object;
		function set userData(value:Object):void;
		function get type():String;
		function get collisionId():String;
		function get collisionAccepts():Array;
		function get hits():int;
		function applyHit():void;
	}
	
}