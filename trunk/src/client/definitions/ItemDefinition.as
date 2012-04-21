package client.definitions 
{
	/**
	 * ...
	 * @author Fulvio Crescenzi
	 */
	public class ItemDefinition 
	{
		private var _name:String;
		private var _code:uint;
		private var _icon:String;
		private var _type:String;
		
		private var _itemProps:ItemPropertiesDefinition;
		private var _physicProps:PhysicDefinition;
		private var _areaAffecting:ItemAffectingAreaDefinition;
		
		public function ItemDefinition(name:String, code:uint, icon:String, type:String, props:ItemPropertiesDefinition, physic:PhysicDefinition, affectingArea:ItemAffectingAreaDefinition) 
		{
			_name = name;
			_code = code;
			_icon = icon;
			_type = type;
			
			_itemProps = props;
			_physicProps = physic;
			_areaAffecting = affectingArea;
		}
		
		public function get itemProps():ItemPropertiesDefinition 
		{
			return _itemProps;
		}
		
		public function get physicProps():PhysicDefinition 
		{
			return _physicProps;
		}
		
		public function get areaAffecting():ItemAffectingAreaDefinition 
		{
			return _areaAffecting;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get code():uint 
		{
			return _code;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get icon():String 
		{
			return _icon;
		}
		
	}

}