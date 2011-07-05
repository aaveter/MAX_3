package Main
{
	import Main.Button_press;
	import Main.Formats;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class Zoom_b extends Sprite
	{
		public var curX:Number = 1;
		//rect - прямоугольник видимости объекта маштабирования
		//st - скроллируемый объект
		//zt - маштабируемый объект
		//X - Максимальное уменьшение
		//mmp - если есть мини-карта, то указываем параметр ответственный за отображение видимости на мини-карте.
		public function Zoom_b(rect:Rectangle,st:Sprite,zt:Sprite,X:Number=4,mmp:Number=NaN)
		{

			var minus:Button_press = new Button_press(Formats.Static,"-");
			var plus:Button_press = new Button_press(Formats.Static,"+");

			plus.width = minus.width;
			plus.x = minus.width;
			addChild(minus);
			addChild(plus);
			minus.addEventListener(MouseEvent.CLICK,min);
			plus.addEventListener(MouseEvent.CLICK,pl);
			function min(ev:MouseEvent)
			{
				if (curX < X)
				{
					mmp=mmp/2
					zt.width = zt.width / 2;
					zt.height = zt.height / 2;
					rect.x = rect.x / 2 - rect.width / 4;
					rect.y = rect.y / 2 - rect.height / 4;
					if (rect.x < 0)
					{
						rect.x = 0;
					}
					if (rect.x > zt.width - rect.width)
					{
						rect.x = zt.width - rect.width;
					}
					if (rect.y < 0)
					{
						rect.y = 0;
					}
					if (rect.y > zt.height - rect.height)
					{
						rect.y = zt.height - rect.height;
					}
					zoom();
					curX +=  1;
				}				
			}
			function pl(ev:MouseEvent)
			{
				if (curX > 1)
				{
					mmp=mmp*2
					zt.width = zt.width * 2;
					zt.height = zt.height * 2;
					rect.x = rect.x * 2 + rect.width / 2;
					rect.y = rect.y * 2 + rect.height / 2;
					zoom();
					curX -=  1;
				}				
			}
			function zoom()
			{
				st.scrollRect=rect
				trace(rect)
			}
		}
	}
}