package Main
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;

	public class ScrollBar extends Sprite
	{
		//stp - место где лежит объект прокрутки, туда же кладем и скролл бар
		//st - объект который будем прокручивать,
		//arrow - отрисованная стрелка, она должна быть отцентрализована (коры 0,0 по середине)
		//box - объект который передвигаем для воздействия на главный объект
		//cbord - цвет границы
		//z - указывает направление скроллбара, если 0 то вертик., если 1 то горизонт., если 2 то и то и другое
		//w_all - ширина scrollbar'а, она должна быть кратна 25 для правильной отрисовки.
		//sw - указывает насколько прокручиваем
		//size - указывает размер видимой части
		//size2 - используется при z=2 указывает видимую часть по y, а size тогда указывает видимую часть по x

		public function ScrollBar(stp:Sprite,st:Sprite,ar:Class,box:Class,cbord:uint,z:Number=0,w_all:int=50,sw:Number=10,size:Number=200,size2:Number=150)
		{
			var rect:Rectangle= new Rectangle();
			var all:Sprite = new Sprite  ;
			var all2:Sprite = new Sprite();
			var up:Sprite;
			var down:Sprite;
			var left:Sprite;
			var right:Sprite;
			var wback:int;
			var wbord:int;
			var w_all:int;

			if (z == 0)
			{
				rect = new Rectangle(0,0,st.width,size);
				st.scrollRect = rect;
				all.x = st.width;
				create_all(all,up,down);
			}
			else if (z==1)
			{
				rect = new Rectangle(0,0,size,st.height);
				st.scrollRect = rect;
				all.rotation = 90;
				all.x = size;
				all.y = st.height;
				create_all(all,left,right);
			}
			else if (z==2)
			{
				rect = new Rectangle(0,0,size,size2);
				st.scrollRect = rect;
				all.rotation = 90;
				all.x = size;
				all.y = size2;
				all2.x = size;
				create_all(all,up,down,size);
				create_all(all2,left,right,size2);
			}
			function create_all(all,b1,b2,s)
			{
				b1=new ar();
				b2= new ar();
				b1.width = w_all;
				b2.width = w_all;
				b1.scaleY = b1.scaleX;
				b2.scaleY = b2.scaleX;
				wback = b1.width / 25 * 23;//ширина задника и передвигающегося бокса
				wbord = b1.width / 25;//ширина границ
				var w2:int = b1.width / 25 * 24;
				b1.rotation = 180;
				stp.addChild(all);
				all.addChild(b2);
				all.addChild(b1);
				s -=  b1.height * 2;
				b1.x = b1.width / 2;
				b1.y = b1.height / 2;
				all.graphics.beginFill(0xFF0000,0);
				//all.graphics.drawRect(wbord,b1.height,wback,s);
				all.graphics.beginFill(cbord,1);
				all.graphics.drawRect(0,b1.height,wbord,s);
				all.graphics.drawRect(w2,b1.height,wbord,s);
				b2.x = b2.width / 2;
				b2.y = s + b1.height * 1.5;
				//all.addEventListener(MouseEvent.CLICK,all_cl);
				//function all_cl(ev:MouseEvent)
				//{
				//if (ev.stageY - stp.y > b1.height + s && ev.stageY - stp.y < st.height)
				//{
				//rect.y +=  sw;
				//st.scrollRect = rect;
				//}
				//else if (ev.stageY-stp.y < b1.height)
				//{
				//rect.y -=  sw;
				//st.scrollRect = rect;
				//}
				//else if (ev.stageX - stp.x > b1.width + s && ev.stageX - stp.x < st.width)
				//{
				//rect.x +=sw
				//st.scrollRect = rect
				//}
				//else if (ev.stageX-stp.x < b1.width)
				//{
				//rect.x -=sw
				//st.scrollRect = rect
				//}
				//}
			}
		}
	}
}