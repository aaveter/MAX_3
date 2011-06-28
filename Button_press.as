package Main
{
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;

	public class Button_press extends Sprite
	{
		var txt:TextField = new TextField  ;
		public function Button_press(f,t:String="ОК")
		{
			var up:Sprite=new Sprite();
			var down:Sprite=new Sprite();
			var s:int = 6;//размер сдвига
			var downing:Number = 0;//сосстояние кнопки 0 - не нажата, 1 - нажата
			var on:Number = 0;//0 - вне кнопки, 1 - над кнопкой
			up.graphics.beginFill(0x00FF66);
			up.graphics.drawRoundRect(0,0,150,40,20);
			down.graphics.beginFill(0x99FF99);
			down.graphics.drawRoundRect(0,s,150,40,20);
			txt.text = t;
			txt.setTextFormat(f);
			txt.width = txt.textWidth + 5;
			txt.mouseEnabled = false;
			up.width = txt.textWidth + 30;
			down.width = txt.textWidth + 30;
			up.x = s;
			txt.x = 20;
			txt.y = 5;			
			this.addChild(down);
			this.addChild(up);
			this.addChild(txt);

			up.addEventListener(MouseEvent.MOUSE_OVER,over);
			up.addEventListener(MouseEvent.MOUSE_OUT,out);
			up.addEventListener(MouseEvent.MOUSE_DOWN,down_b);			

			function over()
			{
				up.graphics.clear();
				up.graphics.beginFill(0x00D936);
				up.graphics.drawRoundRect(0,0,150,40,20);
				up.width = txt.textWidth + 30;
				if (downing == 1)
				{
					up.x = s / 2;
					up.y = s / 2;
					txt.x = 20 - s / 2;
					txt.y = 5 + s / 2;
				}
				on = 1;
			}
			function out()
			{
				if (downing == 0)
				{
					up.graphics.clear();
					up.graphics.beginFill(0x00FF66);
					up.graphics.drawRoundRect(0,0,150,40,20);
					up.width = txt.textWidth + 30;
				}
				else if (downing == 1)
				{
					up.x = s;
					up.y = 0;
					txt.x = 20;
					txt.y = 5;
				}
				on = 0;
			}
			function down_b()
			{
				up.x = s / 2;
				up.y = s / 2;
				txt.x = 20 - s / 2;
				txt.y = 5 + s / 2;
				downing = 1;
				stage.addEventListener(MouseEvent.MOUSE_UP,up_b);
			}
			function up_b()
			{
				up.x = s;
				up.y = 0;
				txt.x = 20;
				txt.y = 5;
				downing = 0;
				if (on == 0)
				{
					out();
				}
			}
		}
	}
}