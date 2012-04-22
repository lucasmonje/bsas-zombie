package client.b2 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import client.definitions.PhysicDefinition;
	import client.utils.B2Utils;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author lmonje
	 */
	public class BoxBuilder {
		
		public static function build(stageBounds:Rectangle, world:b2World, worldScale:Number, isDynamic:Boolean = false, physicProps:PhysicDefinition = null, userData:Object = null):Box {
			var worldBounds:Rectangle = new Rectangle((stageBounds.x + (stageBounds.width/2)) / worldScale, (stageBounds.y + (stageBounds.height / 2)) / worldScale, (stageBounds.width / 2) * (1 / worldScale), (stageBounds.height / 2) * (1 / worldScale))
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(worldBounds.width, worldBounds.height);
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			if (isDynamic) {
				bodyDef.type=b2Body.b2_dynamicBody;				
			}
			if (userData) {
				bodyDef.userData = userData;				
			}
			bodyDef.position.Set(worldBounds.x, worldBounds.y);
			
			var box:Box = new Box(bodyDef, world);
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			if (physicProps) {
				fixture.density = physicProps.density;
				fixture.friction = physicProps.friction;
				fixture.restitution = physicProps.restitution;				
			}
			fixture.shape = shape;
			box.CreateFixture(fixture);
			//box.ResetMassData();
			box.initialStageBounds = stageBounds;
			box.initialWorldBounds = worldBounds;
			box.userData = userData;
			box.physicProps = physicProps;
			box.isDynamic = isDynamic;
			return box;
		}
		
	}

}