package com.sevenbrains.trashingDead.b2 
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	import com.sevenbrains.trashingDead.interfaces.Collisionable;
	
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public class Clientb2ContactListener extends b2ContactListener 
	{
		
		public function Clientb2ContactListener() 
		{
			
		}
		
		override public function BeginContact(contact:b2Contact):void {
			super.BeginContact(contact);
			
			var fix1:b2Fixture = contact.GetFixtureA();
			var fix2:b2Fixture = contact.GetFixtureB();
			var body1:PhysicInformable = fix1.GetBody() as PhysicInformable;
			var body2:PhysicInformable = fix2.GetBody() as PhysicInformable;
			
			var entityA:Collisionable = Collisionable(body1.userData.entity);
			var entityB:Collisionable = Collisionable(body2.userData.entity);
			
			if (validateCollision(entityA, entityB)) {
				entityA.collide(entityB);
				entityB.collide(entityA);
			}
		}
		
		private function validateCollision(entityA:Collisionable, entityB:Collisionable):Boolean {
			return (entityA.collisionable && entityB.collisionable) && (entityA.isCollisioning(entityB) || entityB.isCollisioning(entityA));
		}
	}

}
