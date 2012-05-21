package com.sevenbrains.trashingDead.display.popup {
	import com.sevenbrains.trashingDead.display.popup.nodes.IPopupNode;
	
	public class PopupProperties {
		private var _assetId:String;
		private var _popupId:String;
		private var _channel:String;
		private var _animation:Array;
		private var _nodes:Array;
		
		public function PopupProperties(popupId:String, assetId:String, channel:String, animation:Array) {
			_assetId = assetId;
			_popupId = popupId;
			_channel = channel;
			_animation = animation;
			_nodes = [];
		}
		
		public function get assetId():String {
			return _assetId;
		}
		
		public function get popupId():String {
			return _popupId;
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
		
		public function get animation():Array {
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