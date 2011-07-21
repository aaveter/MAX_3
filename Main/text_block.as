package Main
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.ui.*;
	import flash.display.Stage

	public class text_block extends Sprite
	{
		public var T:TextField=new TextField();
		// tbt - цель, на которой появляется надпись
		// txt - текст, на кнопке
		public function text_block(tbt:Sprite,txt:String,tf:TextFormat)
		{			
			addChild(T);
			tbt.addChild(this);
			T.text = txt;
			T.setTextFormat(tf);
			T.width = T.textWidth * 1.2;
			T.height = T.textHeight * 1.2;
			T.border = true;
			T.background = true;
			T.mouseEnabled = false;
			x=(tbt.width/tbt.scaleX-width)/2;
			y=(tbt.height/tbt.scaleY-height)/2;
			addEventListener(MouseEvent.MOUSE_OVER, over);
			addEventListener(MouseEvent.MOUSE_OUT, out);
			function over(ev:MouseEvent)
			{
				Mouse.cursor = MouseCursor.BUTTON;
			}
			function out(ev:MouseEvent)
			{
				Mouse.cursor = MouseCursor.AUTO;
			}
		}
		public function replace(STAGE:Stage)
		{
			x=(STAGE.stageWidth-width)/2;
			y=(STAGE.stageHeight-height)/2;
		}
	}
}