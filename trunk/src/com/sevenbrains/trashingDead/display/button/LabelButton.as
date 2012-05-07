package com.sevenbrains.trashingDead.display.button
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class LabelButton extends GenericButton
	{
		private static const LABEL_SPRITE_NAME :String = "label";
		private static const LABEL_TEXTFIELD_NAME :String = "txtLabel";

		private static const DEFAULT_FONT_NAME :String = "Arial";

		protected var m_label :TextField;
		protected var m_format :TextFormat;

		public function LabelButton(mc:MovieClip)
		{
			super(mc);
			m_format = new TextFormat();
			initialize();
		}

		override public function destroy():void
		{
			super.destroy();
			m_label = null;
			m_format = null;
		}

		private function initialize() :void
		{
			var mcLabel :Sprite = display.getChildByName(LABEL_SPRITE_NAME) as Sprite;
			if (!mcLabel)
				throw new Error("Button without label sprite");

			 m_label = mcLabel.getChildByName(LABEL_TEXTFIELD_NAME) as TextField;
			 if (!m_label)
				throw new Error("Button without label textfield");

			 //As we have embed fonts
/*			embedFonts = false;
			font = DEFAULT_FONT_NAME;*/
			text = '';
		}

		public function get text() :String { return m_label.text; }

		public function set text(value :String) :void
		{
			m_label.text = value;
		}

		public function get font() :String { return m_format.font; }

		public function set font(name :String) :void
		{
			m_format.font = name;
			updateTextFormat();
		}
		
		public function get fontSize() :Number { return m_format.size as Number; }
		
		public function set fontSize(value:Number) :void
		{
			m_format.size = value;
			updateTextFormat();
		}

		public function get boldFont() :Boolean { return m_format.bold !== true; }

		public function set boldFont(value :Boolean) :void
		{
			m_format.bold = value;
			updateTextFormat();
		}

		public function get embedFonts() :Boolean { return m_label.embedFonts; }

		public function set embedFonts(value :Boolean) :void
		{
			m_label.embedFonts = value;
			updateTextFormat();
		}

	    private function updateTextFormat():void
	    {
	        m_label.defaultTextFormat = m_format;
	        m_label.setTextFormat(m_format);
	    }
	}
}