package com.sevenbrains.trashingDead.display.popup
{
	import com.sevenbrains.trashingDead.display.loaders.Asset;
	import com.sevenbrains.trashingDead.display.popup.nodes.IPopupNode;
	

	/**
	 * @author Ariel
	 * <br>modified by matias.munoz
	 */
	public class PopupProperties
	{
		private var _asset:Asset;
		private var _i18n:String;
		private var _center:Boolean;
		private var _nodes:Array;
		
		public function PopupProperties(asset:Asset, i18n:String='', center:Boolean=true)
		{
			_asset = asset;
			_i18n = i18n;
			_center = center;
			_nodes = [];
		}


		public function get asset():Asset
		{
			return _asset;
		}

		public function get i18n():String
		{
			return _i18n;
		}

		public function get center():Boolean
		{
			return _center;
		}

		public function get nodes():Array
		{
			return _nodes.concat();
		}
		
		public function set nodes(value:Array):void
		{
			_nodes = value;
		}
		
		public function addNode(node:IPopupNode):void
		{
			_nodes.push(node);
		}
		
		public function append(props:PopupProperties):void
		{
			for each (var node:IPopupNode in props._nodes) 
			{
				addNode(node);
			}
		}
	}
}