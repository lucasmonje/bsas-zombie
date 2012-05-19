//------------------------------------------------------------------------------
//
//	This software is the confidential and proprietary information of   
//	7 Brains. You shall not disclose such Confidential Information and   
//	shall use it only in accordance with the terms of the license   
//	agreement you entered into with 7 Brains.  
//	Copyright 2012 - 7 Brains. 
//	All rights reserved.  
//
//------------------------------------------------------------------------------
package com.sevenbrains.trashingDead.definitions {
	
	import com.sevenbrains.trashingDead.interfaces.IClassifiable;
	
	
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemDefinition implements IClassifiable {
		
		private var _animations:Vector.<AnimationDefinition>;
		
		private var _code:uint;
		
		private var _damageArea:DamageAreaDefinition;
		
		private var _icon:String;
		
		private var _collisionDefinition:CollisionDefinition;
		
		private var _name:String;
		
		private var _physicProps:PhysicDefinition;
		
		private var _type:String;
		
		public function ItemDefinition(name:String, code:uint, icon:String, type:String, collisionDef:CollisionDefinition = null, physic:PhysicDefinition = null, damageArea:DamageAreaDefinition = null, animations:Vector.<AnimationDefinition> = null) {
			_name = name;
			_code = code;
			_icon = icon;
			_type = type;
			_collisionDefinition = collisionDef;
			_physicProps = physic;
			_damageArea = damageArea;
			_animations = animations;
		}
		
		public function get animations():Vector.<AnimationDefinition> {
			return _animations;
		}
		
		public function get code():uint {
			return _code;
		}
		
		public function get damageAreaProps():DamageAreaDefinition {
			return _damageArea;
		}
		
		public function get icon():String {
			return _icon;
		}
		
		public function get collisionDef():CollisionDefinition {
			return _collisionDefinition;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get physicProps():PhysicDefinition {
			return _physicProps;
		}
		
		public function get type():String {
			return _type;
		}
	}
}