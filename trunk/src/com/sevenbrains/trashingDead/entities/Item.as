package com.sevenbrains.trashingDead.entities 
{
	import com.sevenbrains.trashingDead.enum.PhysicObjectType;
	import com.sevenbrains.trashingDead.definitions.ItemDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Item extends Entity 
	{
		
		public function Item(props:ItemDefinition, initialPosition:Point) 
		{
			super(props, initialPosition, PhysicObjectType.ITEM);
		}
		
	}

}