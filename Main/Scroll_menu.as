package Main
{
	import Main.ScrollBar;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class Scroll_menu
	{
		public var scroll_y:ScrollBar;
		public var scroll_x:ScrollBar;
		public var st_w:int;
		public var st_h:int;
		public var rect:Rectangle
		
		//stp - место где лежит объект прокрутки, туда же кладем и скролл бар
		//st - объект который будем прокручивать,
		//ar - отрисованная стрелка, она должна быть отцентрализована (коры 0,0 по середине)
		//b - объект который передвигаем для воздействия на главный объект
		//cbord - цвет границы
		//z - указывает направление скроллбара, если 0 то вертик., если 1 то горизонт., если 2 то и то и другое
		//w_all - ширина scrollbar'а
		//sw - указывает насколько прокручиваем
		//size1 - указывает размер видимой части
		//size2 - используется при z=2 указывает видимую часть по x, а size1 тогда указывает видимую часть по y

		public function Scroll_menu(stp:Sprite,st:Sprite,ar:Class,b:Class,cbord:uint=0x0000FF,z:int=2,w_all:int=50,sw:int=10,size1:int=150,size2:int=200)
		{			
			st_w = st.width;
			st_h = st.height;
			if (z == 0)
			{
				rect=new Rectangle(0,0,st_w,size1)
				scroll_y = new ScrollBar(rect,stp,st,ar,b,cbord,z,w_all,sw,size1);
				scroll_y.x = st_w;
				stp.addChild(scroll_y);
			}
			else if (z == 1)
			{				
				rect=new Rectangle(0,0,size1,st_h)
				scroll_x = new ScrollBar(rect,stp,st,ar,b,cbord,z,w_all,sw,size1);
				scroll_x.rotation=-90
				scroll_x.y = st_h+scroll_x.height;				
				stp.addChild(scroll_x);
			}
			else if (z == 2)
			{
				rect=new Rectangle(0,0,size2,size1)
				scroll_y = new ScrollBar(rect,stp,st,ar,b,cbord,0,w_all,sw,size1);
				scroll_x = new ScrollBar(rect,stp,st,ar,b,cbord,1,w_all,sw,size2);
				scroll_x.rotation=-90
				scroll_y.x = size2;				
				scroll_x.y = size1+scroll_x.height;
				stp.addChild(scroll_y);
				stp.addChild(scroll_x);
			}
		}
	}
}