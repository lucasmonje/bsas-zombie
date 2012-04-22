package client.b2 
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	/**
	 * ...
	 * @author ...
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
			
			if (validateCollision(body1, body2)) {
				body1.applyHit();
			}
			
			if (validateCollision(body2, body1)) {
				body2.applyHit();	
			}
		}
		
		private function validateCollision(body1:PhysicInformable, body2:PhysicInformable):Boolean {
			return body2.collisionAccepts.indexOf(body1.collisionId) > -1;
		}
	}

}
