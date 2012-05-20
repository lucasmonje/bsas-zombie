//------------------------------------------------------------------------------
//
//   Trashing Dead 
//   7 Brains Studio 
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.sevenbrains.trashingDead.definitions {
	
	import com.sevenbrains.trashingDead.interfaces.IClassifiable;
	import com.sevenbrains.trashingDead.models.trade.ITradeValue;
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemDefinition implements IClassifiable {
		
		private var _animations:Vector.<AnimationDefinition>;
		
		private var _code:uint;
		
		private var _collisionDefinition:CollisionDefinition;
		
		private var _cost:ITradeValue;
		
		private var _damageArea:DamageAreaDefinition;
		
		private var _icon:String;
		
		private var _lock:LockDefinition;
		
		private var _name:String;
		
		private var _physicProps:PhysicDefinition;
		
		private var _reward:ITradeValue;
		
		private var _type:String;
		
		public function ItemDefinition(name:String, code:uint, icon:String, type:String, collisionDef:CollisionDefinition = null, physic:PhysicDefinition = null, damageArea:DamageAreaDefinition = null, animations:Vector.<AnimationDefinition> = null, cost:ITradeValue = null, reward:ITradeValue = null, lockDef:LockDefinition = null) {
			_name = name;
			_code = code;
			_icon = icon;
			_type = type;
			_collisionDefinition = collisionDef;
			_physicProps = physic;
			_damageArea = damageArea;
			_animations = animations;
			_cost = cost;
			_reward = reward;
			_lock = lockDef;
		}
		
		public function get animations():Vector.<AnimationDefinition> {
			return _animations;
		}
		
		public function get code():uint {
			return _code;
		}
		
		public function get collisionDef():CollisionDefinition {
			return _collisionDefinition;
		}
		
		public function get cost():ITradeValue {
			return _cost;
		}
		
		public function get damageAreaProps():DamageAreaDefinition {
			return _damageArea;
		}
		
		public function get icon():String {
			return _icon;
		}
		
		public function get lock():LockDefinition {
			return _lock;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get physicProps():PhysicDefinition {
			return _physicProps;
		}
		
		public function get reward():ITradeValue {
			return _reward;
		}
		
		public function get type():String {
			return _type;
		}
	}
}