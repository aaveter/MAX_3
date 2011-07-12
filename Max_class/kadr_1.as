package Max_class
{
	import Main.*;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class kadr_1 extends Sprite
	{
		public function kadr_1(stage)
		{
			var colors:Array = new Array(0xFF0000,0xFFFF00,0xFF00FF,0x00FFFF,0x333300);//массив цветов для игроков
			var n_txt:Array = new Array("2","3","4","5");//Массив значений для круглых кнопок
			var r:Panel_rb = new Panel_rb(n_txt,4,0x0000FF,0x00FF99,0x00FF99,0x0000FF,0);
			var u:Panel_txt;
			var b:Button_press;
			var Players:Array=new Array();
			var p:Number=new Number();

			refreshSizes();

			addChild(r);
			r.x = (Game.doc_x-r.width)/2;
			r.y = 50;
			r.addEventListener(MouseEvent.CLICK,press_p);
			
			function refreshSizes() {
				graphics.clear();
				graphics.lineStyle(4,0x000000);
				graphics.drawRect(0,0,Game.doc_x,Game.doc_y);
			}

			function press_p(ev:MouseEvent)
			{
				p = r.ch.txt.text;
				if (u != null)
				{
					removeChild(u);
					removeChild(b);
				}
				u = new Panel_txt(colors,r.ch.txt.text,"игрок",r.width);
				addChild(u);
				u.x = (Game.doc_x-u.width)/2;
				u.y = r.y + r.height + 20;
				b = new Button_press(Formats.Static);
				b.addEventListener(MouseEvent.CLICK,press_b);
				addChild(b);
				b.x=(Game.doc_x-b.width)/2;
				b.y = u.y + u.height + 20;
			}
			function press_b(ev:MouseEvent)
			{
				for (var i:int=0; i<p; i++)
				{
					Players[i] = new Player(u.all_txt[i].text,u.all_bc[i].color);
				}
				var k2:kadr_2=new kadr_2();
				Game.setKadr(k2);
			}
		}
	}
}