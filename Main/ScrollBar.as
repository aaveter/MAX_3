package Main
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;

	public class ScrollBar extends Sprite
	{
		var box:Sprite;
		var rect:Rectangle;
		var st_size:Number;
		var s:Number;
		var st_spr:Sprite;
		var shift:int;
		var bar:Sprite = new Sprite  ;

		//r - прямоугольник видимости
		//stp - место где лежит объект прокрутки, туда же кладем и скролл бар
		//st - объект который будем прокручивать,
		//ar - отрисованная стрелка, она должна быть отцентрализована (коры 0,0 по середине)
		//box - объект который передвигаем для воздействия на главный объект
		//cbord - цвет границы
		//z - указывает направление скроллбара, если 0 то вертик., если 1 то горизонт.
		//w_all - ширина scrollbar'а
		//sw - указывает насколько прокручиваем
		//size - высота места под бар

		public function ScrollBar(r:Rectangle,stp:Sprite,st:Sprite,ar:Class,b:Class,cbord:uint,z:Number=0,w_all:int=50,sw:Number=10,size:Number=200)
		{
			var wback:int = 46;
			var wbord:int = 2;
			var b1:Sprite = new ar  ;
			var b2:Sprite = new ar  ;
			var w:Number=st.width
			var h:Number=st.height

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
			bar.y = b1.height;
			addChild(bar);
			bar.addChild(box);
			bar.width = w_all;
			st_spr.scrollRect = rect;
			bar.addEventListener(MouseEvent.CLICK,all_cl);
			b1.addEventListener(MouseEvent.CLICK,all_cl);
			b2.addEventListener(MouseEvent.CLICK,all_cl);
			box.addEventListener(MouseEvent.MOUSE_MOVE,moving);			

			function create_b(bt:Sprite)
			{
				bt.width = w_all;
				bt.scaleY = bt.scaleX;
				addChild(bt);
			}
			function all_cl(ev:MouseEvent)
			{
				if (z == 0)
				{
					if (ev.stageY - stp.y < b1.height)
					{
						if (rect.y - sw < 0)
						{
							rect.y = 0;
						}
						else
						{
							rect.y -=  sw;
						}
					}
					else if (ev.stageY - stp.y > b1.height + s)
					{
						if (rect.y + sw < st_size - size)
						{
							rect.y +=  sw;
						}
						else
						{
							rect.y = st_size - size;
						}
					}
					else
					{
						box.y = ev.stageY - stp.y - b1.height - box.height / 2;
						if (box.y < 0)
						{
							box.y = 0;
						}
						else if (box.y > s - box.height)
						{
							box.y = s - box.height;
						}
						rect.y = box.y / s * st_size;
					}
					replace(rect.y);
				}
				else if (z == 1)
				{
					if (ev.stageX - stp.x < b1.height)
					{
						if (rect.x - sw < 0)
						{
							rect.x = 0;
						}
						else
						{
							rect.x -=  sw;
						}
					}
					else if (ev.stageX - stp.x > b1.height + s)
					{
						if (rect.x + sw < st_size - size)
						{
							rect.x +=  sw;
						}
						else
						{
							rect.x = st_size - size;
						}
					}
					else
					{
						box.y = ev.stageX - stp.x - b1.height - box.height / 2;
						if (box.y < 0)
						{
							box.y = 0;
						}
						else if (box.y > s - box.height)
						{
							box.y = s - box.height;
						}
						rect.x = box.y / s * st_size;
					}
					replace(rect.x);
				}
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
			box.y = shift / st_size * s;
			st_spr.scrollRect = rect;
		}
	}
}