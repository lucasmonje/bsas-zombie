package client.utils 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import client.definitions.ItemPhysicDefinition;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class B2Utils 
	{
		
			public static function setRevoluteJoint(body1:b2Body, body2:b2Body, world:b2World, lowerAngle:int = -0.15, upperAngle:int = 0.15, enableLimit:Boolean  = true, maxMotorTorque:int = 10, motorSpeed:int = 0, enableMotor:Boolean = true):b2RevoluteJointDef {
				var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
				revoluteJointDef.Initialize(body1, body2, body1.GetWorldCenter());
				revoluteJointDef.lowerAngle = lowerAngle; 
				revoluteJointDef.upperAngle = upperAngle;
				revoluteJointDef.enableLimit = enableLimit;
				revoluteJointDef.maxMotorTorque = maxMotorTorque;
				revoluteJointDef.motorSpeed = motorSpeed;
				revoluteJointDef.enableMotor = enableMotor;
				world.CreateJoint(revoluteJointDef);
				return revoluteJointDef;
			}
			
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