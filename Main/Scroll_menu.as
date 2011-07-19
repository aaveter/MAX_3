package Main
{
	import Main.ScrollBar;
	import flash.display.*;
	import flash.net.URLLoader;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.events.Event;

	public class Scroll_menu extends Sprite
	{
		public var scroll_y:ScrollBar;
		public var scroll_x:ScrollBar;
		public var st_w:int;
		public var st_h:int;
		public var rect:Rectangle;
		public var xyz:int = new int ;//Определяет какие варианты скроллбаров имеются		
		
		//st - объект который будем прокручивать,
		//ar - отрисованная стрелка, она должна быть отцентрализована (коры 0,0 по середине)
		//b - объект который передвигаем для воздействия на главный объект
		//cbord - цвет границы
		//z - указывает направление скроллбара, если 0 то вертик., если 1 то горизонт., если 2 то и то и другое
		//w_all - ширина scrollbar'а
		//sw - указывает насколько прокручиваем
		//size1 - указывает размер видимой части
		//size2 - используется при z=2 указывает видимую часть по x, а size1 тогда указывает видимую часть по y		

		public function Scroll_menu(st:Sprite,ar:Class,b:Class,cbord:uint=0x0000FF,z:int=2,w_all:int=50,sw:int=10,size1:int=150,size2:int=200)
		{			
			st_w = st.width;
			st_h = st.height;
			xyz = z;
			addChild(st)
			if (z == 0)
			{
				rect = new Rectangle(0,0,st_w,size1);
				scroll_y = new ScrollBar(rect,st,ar,b,cbord,z,w_all,sw,size1);
				scroll_y.x = st_w;
				addChild(scroll_y);
			}
			else if (z == 1)
			{
				rect = new Rectangle(0,0,size1,st_h);
				scroll_x = new ScrollBar(rect,st,ar,b,cbord,z,w_all,sw,size1);
				scroll_x.rotation = -90;
				scroll_x.y = st_h + scroll_x.height;
				addChild(scroll_x);
			}
			else if (z == 2)
			{
				rect = new Rectangle(0,0,size2,size1);
				scroll_y = new ScrollBar(rect,st,ar,b,cbord,0,w_all,sw,size1);
				scroll_x = new ScrollBar(rect,st,ar,b,cbord,1,w_all,sw,size2);
				scroll_x.rotation = -90;
				scroll_y.x = size2;
				scroll_x.y = size1 + scroll_x.height;
				addChild(scroll_y);
				addChild(scroll_x);
			}
			st.addEventListener(MouseEvent.MOUSE_DOWN,map_down);
			function map_down(event:MouseEvent)
			{
				var mouse_x = mouseX;
				var mouse_y = mouseY;
				st.addEventListener(MouseEvent.MOUSE_MOVE,map_move);
				function map_move(event:MouseEvent)
				{
					if (rect.x+(mouse_x-mouseX)<0)
					{
						rect.x = 0;
					}
					else if (rect.x+(mouse_x-mouseX)>st_w-size2)
					{
						rect.x = st_w - size2;
					}
					else
					{
						rect.x+=(mouse_x-mouseX);
					}
					mouse_x = mouseX;

					if (rect.y+(mouse_y-mouseY)<0)
					{
						rect.y = 0;
					}
					else if (rect.y+(mouse_y-mouseY)>st_h-size1)
					{
						rect.y = st_h - size1;
					}
					else
					{
						rect.y+=(mouse_y-mouseY);
					}
					mouse_y = mouseY;

					st.scrollRect = rect;
				}
				st.addEventListener(MouseEvent.MOUSE_UP,map_stop);
				st.addEventListener(MouseEvent.ROLL_OUT,map_stop);
				function map_stop(event:MouseEvent)
				{
					st.removeEventListener(MouseEvent.MOUSE_MOVE,map_move);
					st.removeEventListener(MouseEvent.MOUSE_UP,map_stop);
					st.removeEventListener(MouseEvent.ROLL_OUT,map_stop);
				}
			}
			addEventListener(Event.RESIZE,resize_me);
			function resize_me(ev:Event)
			{
				// переразмериваем
				size1 = width;
				scroll_x.width = size1;
				size2 = height;
				scroll_y.height = size2;
			}
		}
		public function resize_me(size_x,size_y)
		{
			rect.width = size_x;
			rect.height = size_y;
			if (xyz == 0)
			{
				scroll_y.x = size_x;
				scroll_y.resize_me(size_y,rect.y)
			}
			else if (xyz == 1)
			{
				scroll_x.y = size_y + scroll_x.height;
				scroll_x.resize_me(size_x,rect.x)
			}
			else if (xyz == 2)
			{
				scroll_y.x = size_x;
				scroll_y.resize_me(size_y,rect.y)
				scroll_x.y = size_y + scroll_x.height;
				scroll_x.resize_me(size_x,rect.x)
			}			
		}
	}
}