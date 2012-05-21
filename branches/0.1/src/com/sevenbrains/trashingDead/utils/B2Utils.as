package com.sevenbrains.trashingDead.utils 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import com.sevenbrains.trashingDead.definitions.PhysicDefinition;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author lmonje
	 */
	public class B2Utils 
	{
		
		public static function setRevoluteJoint(body1:b2Body, body2:b2Body, anchor:b2Vec2, world:b2World, lowerAngle:Number = -0.15, upperAngle:Number = 0.15, enableLimit:Boolean  = true, maxMotorTorque:Number = 10, motorSpeed:Number = 0, enableMotor:Boolean = true):b2Joint {
			var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			revoluteJointDef.Initialize(body1, body2, anchor);
			revoluteJointDef.lowerAngle = lowerAngle; 
			revoluteJointDef.upperAngle = upperAngle;
			revoluteJointDef.enableLimit = enableLimit;
			revoluteJointDef.maxMotorTorque = maxMotorTorque;
			revoluteJointDef.motorSpeed = motorSpeed;
			revoluteJointDef.enableMotor = enableMotor;
			return world.CreateJoint(revoluteJointDef);
		}
			
		public static function createBox(worldBounds:Rectangle, world:b2World, body:b2Body = null, isDynamic:Boolean = false, physicProps:PhysicDefinition = null, userData:Object = null):b2Body {
			
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
			
			body = world.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			body.ResetMassData();
			return body;
		}
		
	}

}