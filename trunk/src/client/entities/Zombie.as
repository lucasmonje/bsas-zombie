package client.entities 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class Zombie extends Sprite
	{
		
		public function Zombie() 
		{
			
		}
		
		private function init(w:Number, h:Number, px:Number, py:Number, worldScale:int):void {
			
			var blockShape:b2PolygonShape = new b2PolygonShape();
			blockShape.SetAsBox(w/worldScale,h/worldScale);
			
			var blockFixture:b2FixtureDef = new b2FixtureDef();
			blockFixture.density=0.5;
			blockFixture.friction=10;
			blockFixture.restitution=0.1;
			blockFixture.shape=blockShape;
			
			var blockBodyDef:b2BodyDef = new b2BodyDef();
			blockBodyDef.position.Set(px/worldScale,py/worldScale);
			rock=new Rock();
			rock.width=w*2;
			rock.height=h*2;
			addChild(rock);
			blockBodyDef.userData={assetName:"block",assetSprite:rock,remove:false};
			blockBodyDef.type=b2Body.b2_dynamicBody;
			
			var block:b2Body=world.CreateBody(blockBodyDef);
			block.CreateFixture(blockFixture);
		}
	}

}