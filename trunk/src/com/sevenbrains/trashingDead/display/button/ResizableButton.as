package com.sevenbrains.trashingDead.display.button
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;

	public class ResizableButton extends LabelButton
	{
		private var _leftMargin :Number;
		private var _rightMargin :Number;
		
		public function ResizableButton(mc:MovieClip, leftMargin :Number = 5, rightMargin :Number = 5)
		{
			super(mc);
			this._leftMargin = leftMargin;
			this._rightMargin = rightMargin;
		}
		
		override public function set text(value :String) :void {
			super.text = value;
			resize();
		}
		
		protected function resize() :void{
			
			var frameContainer :Sprite = this.display.frame as Sprite;
			var frame :Sprite;
			if (frameContainer) {
				frame = frameContainer.getChildByName("mc") as Sprite;
			}
			var back :Sprite = this.display.back.mc as Sprite;
			var shadow :Sprite = this.display.shadow.mc as Sprite;
			var icon:Sprite = this.display.icon as Sprite;
			
			this.m_label.x = leftMargin;
			this.m_label.autoSize = TextFieldAutoSize.LEFT;
			this.m_label.wordWrap  = false;
			var shadowDiff :Number = shadow.width - back.width;
			var backWidth :Number = _leftMargin + this.m_label.width + _rightMargin;
			
			var frameDiff :Number = 0;
			if (frame) {
				frameDiff = frame.width - back.width;
			}
			
			shadow.width = backWidth + shadowDiff;
			back.width = backWidth;
			if (frame) {
				frame.width = backWidth + frameDiff;
			}
			
			if(icon){
				icon.x = backWidth - leftMargin - 12;
				icon.y -= 2;
			}
			
		}
		
		public function get leftMargin() :Number {
			return this._leftMargin;
		}
		
		public function set leftMargin(value :Number) :void {
			this._leftMargin = value;
		}
		
		public function get rightMargin() :Number {
			return this._rightMargin;
		}
		
		public function set rightMargin(value :Number) :void {
			this._rightMargin = value;
		}
	}
}