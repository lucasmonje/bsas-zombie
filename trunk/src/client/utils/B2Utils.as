package client.utils 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import client.definitions.ItemPhysicDefinition;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class B2Utils 
	{
		
		public static function createBox(bounds:Rectangle, world:b2World, worldScale:Number, isDynamic:Boolean = false, physicProps:ItemPhysicDefinition = null, userData:Object = null):b2Body {
			
			var shape:b2PolygonShape = new b2PolygonShape();
			var hx:Number = (bounds.width / 2) * (1 / worldScale);
			var hy:Number = (bounds.height / 2) * (1 / worldScale);
			shape.SetAsBox(hx, hy);
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			if (physicProps) {
				fixture.density = physicProps.density;
				fixture.friction = physicProps.friction;
				fixture.restitution = physicProps.restitution;				
			}
			fixture.shape = shape;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			if (isDynamic) {
				bodyDef.type=b2Body.b2_dynamicBody;				
			}
			if (userData) {
				bodyDef.userData = userData;				
			}
			bodyDef.position.Set(bounds.x / worldScale, bounds.y / worldScale);
			
			var body:b2Body = world.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			body.ResetMassData();
			return body;
		}
		
	}

}