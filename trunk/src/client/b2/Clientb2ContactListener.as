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
			var userData:Object;
			discountHits(contact.GetFixtureA());
			discountHits(contact.GetFixtureB());
		}
		
		private function discountHits(fix:b2Fixture):void {
			var body:b2Body = fix.GetBody();
			var userData:Object = body.GetUserData();
			if (Boolean(userData)) {
				if (Boolean(userData.hits)) {
					userData.hits--;
					body.SetUserData(userData);					
				}
			}
		}
	}

}