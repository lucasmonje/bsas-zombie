package com.sevenbrains.trashingDead.display.popup {
	import com.sevenbrains.trashingDead.display.popup.nodes.IPopupNode;
	
	public class PopupProperties {
		private var _assetId:String;
		private var _i18n:String;
		private var _channel:String;
		private var _animation:String;
		private var _nodes:Array;
		
		public function PopupProperties(assetId:String, i18n:String, channel:String, animation:String) {
			_assetId = assetId;
			_i18n = i18n;
			_channel = channel;
			_animation = animation;
			_nodes = [];
		}
		
		public function get assetId():String {
			return _assetId;
		}
		
		public function get i18n():String {
			return _i18n;
		}
		
		public function get nodes():Array {
			return _nodes.concat();
		}
		
		public function set nodes(value:Array):void {
			_nodes = value;
		}
		
		public function get channel():String {
			return _channel;
		}
		
		public function get animation():String {
			return _animation;
		}
		
		public function addNode(node:IPopupNode):void {
			_nodes.push(node);
		}
		
		public function append(props:PopupProperties):void {
			for each (var node:IPopupNode in props.nodes) {
				addNode(node);
			}
		}
	}
}