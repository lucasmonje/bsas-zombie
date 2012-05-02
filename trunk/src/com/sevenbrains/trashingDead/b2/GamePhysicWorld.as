package com.sevenbrains.trashingDead.b2 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import com.sevenbrains.trashingDead.entities.Entity;
	import com.sevenbrains.trashingDead.utils.ArrayUtil;
	
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public class GamePhysicWorld extends b2World 
	{		
		public function GamePhysicWorld(gravity:b2Vec2, doSleep:Boolean) 
		{
			super(gravity, doSleep);
		}
	}

}