package Main
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class ScrollBar extends Sprite
	{
		public var box:Sprite;
		var rect:Rectangle;//прямоугольник прокрутки
		var st_size:Number;//размер карты по интересующей скролл стороне
		var s:Number;
		public var sh:Number;
		var st_spr:Sprite;//прокручиваемый объект
		var shift:int;//размер сдвига
		var bar:Sprite = new Sprite  ;//столбик прокрутки
		var b1:Sprite = new Sprite  ;//верхняя кнопка
		var b2:Sprite = new Sprite  ;//нижняя кнопка
		var size:Number = new Number  ;//размер видимой части карты  ;
		var xyz:int = new int  ;//Определяет какие варианты скроллбаров имеются

		//r - прямоугольник видимости		
		//st - объект который будем прокручивать,
		//ar - отрисованная стрелка, она должна быть отцентрализована (коры 0,0 по середине)
		//b - объект который передвигаем для воздействия на главный объект
		//cbord - цвет границы
		//z - указывает направление скроллбара, если 0 то вертик., если 1 то горизонт.
		//w_all - ширина scrollbar'а
		//sw - указывает насколько прокручиваем
		//size - высота места под бар

		public function ScrollBar(r:Rectangle,st:Sprite,ar:Class,b:Class,cbord:uint,z:Number=0,w_all:int=50,sw:Number=10,sz:Number=200)
		{
			var wback:int = 46;
			var wbord:int = 2;
			b1 = new ar  ;
			b2 = new ar  ;
			size = sz;
			xyz=z
			var w:Number = st.width;
			var h:Number = st.height;
			var bar_spr:Sprite = new Sprite  ;

			box = new b  ;
			rect = r;
			st_spr = st;
			if (z == 0)
			{
				st_size = st_spr.height;
			}
			else if (z == 1)
			{
				st_size = st_spr.width;
			}
			create_b(b1);
			create_b(b2);

			s = size - b1.height * 2;
			sh= s / (st_size / size);
			box.width = wback;
			box.height = s / (st_size / size);
			box.x = wbord;
			b1.x = b1.width / 2;
			b1.y = b1.height / 2;
			b1.rotation = 180;
			b2.x = b2.width / 2;
			b2.y = size - b1.height / 2;
			bar.graphics.beginFill(0xFF0000,0);
			bar.graphics.drawRect(wbord,0,wback,s);
			bar.graphics.beginFill(cbord);
			bar.graphics.drawRect(0,0,wbord,s);
			bar.graphics.drawRect(wback + wbord,0,wbord,s);
			bar_spr.y = b1.height;
			addChild(bar_spr);
			bar_spr.addChild(bar);
			bar_spr.addChild(box);
			bar_spr.width = w_all;
			st_spr.scrollRect = rect;
			bar_spr.addEventListener(MouseEvent.CLICK,all_cl);
			b1.addEventListener(MouseEvent.CLICK,all_cl);
			b2.addEventListener(MouseEvent.CLICK,all_cl);
			bar_spr.addEventListener(MouseEvent.MOUSE_MOVE,moving);

			function create_b(bt:Sprite)
			{
				bt.width = w_all;
				bt.scaleY = bt.scaleX;
				addChild(bt);
			}
			function all_cl(ev:MouseEvent)
			{
				var shift:Number = new Number  ;
				if (z == 0)
				{
					shift = rect.y;
				}
				else if (z == 1)
				{
					shift = rect.x;
				}
				if (bar_spr.mouseY < 0)
				{
					if (shift - sw < 0)
					{
						shift = 0;
					}
					else
					{
						shift -=  sw;
					}
				}
				else if (bar_spr.mouseY > s)
				{
					if (shift + sw < st_size - size)
					{
						shift +=  sw;
					}
					else
					{
						shift = st_size - size;
					}
				}
				else
				{
					box.y = bar_spr.mouseY - box.height / 2;
					if (box.y < 0)
					{
						box.y = 0;
					}
					else if (box.y > s - box.height)
					{
						box.y = s - box.height;
					}
					shift = box.y / s * st_size;
				}				
				replace(shift);
			}

			function moving(ev:MouseEvent)
			{
				if (ev.buttonDown == true)
				{
					all_cl(ev);
				}
			}
		}
		public function replace(shift)
		{
			box.y = shift / st_size * bar.height;
			if (xyz == 0)
			{
				rect.y = shift;
			}
			else if (xyz == 1)
			{
				rect.x = shift;
			}
			st_spr.scrollRect = rect;
		}
		public function resize_me(sz,shift)
		{
			size = sz;
			bar.height = size - b1.height * 2;
			s = bar.height;
			sh= s / (st_size / size);
			box.height = s / (st_size / size);
			b2.y = size - b1.height / 2;
			if (shift > st_size - size)
			{
				shift = st_size - size;
			}
			replace(shift);
		}
	}
}