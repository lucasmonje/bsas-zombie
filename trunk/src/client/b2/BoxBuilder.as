package client.b2 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import client.definitions.ItemPhysicDefinition;
	import client.utils.B2Utils;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author lmonje
	 */
	public class BoxBuilder {
		
		public static function build(stageBounds:Rectangle, world:b2World, worldScale:Number, isDynamic:Boolean = false, physicProps:ItemPhysicDefinition = null, userData:Object = null):Box {
			var worldBounds:Rectangle = new Rectangle(stageBounds.x / worldScale, stageBounds.y / worldScale, (stageBounds.width / 2) * (1 / worldScale), (stageBounds.height / 2) * (1 / worldScale))
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(worldBounds.width, worldBounds.height);
			
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
			bodyDef.position.Set(worldBounds.x, worldBounds.y);
			
			var box:Box = world.CreateBox(bodyDef);
			box.CreateFixture(fixture);
			box.ResetMassData();
			box.stageBounds = stageBounds;
			box.worldBounds = worldBounds;
			box.userData = userData;
			box.physicProps = physicProps;
			box.isDynamic = isDynamic;
			return box;
		}
		
	}

}