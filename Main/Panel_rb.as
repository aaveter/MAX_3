//Панель для выболра кол-ва игроков
package Main
{
	import Main.Round_button;
	import flash.display.*;
	import flash.events.MouseEvent;

	public class Panel_rb extends Sprite
	{
		public var ch:Object;//выбранная кнопка
		public function Panel_rb(nt:Array,max_q:Number=2,cf1:uint=0x0000FF,cf2:uint=0x00FF99,cs1:uint=0xFF0000,cs2:uint=0x00FF99,n:Number=1,b:uint=0x000000)
		{
			var all_q:Array = new Array();//массив кнопок
			var dist:Number = 10;//Расстояние между кнопками			
			var colors:Array = new Array(cf1,cf2);
			var alphas:Array = new Array(1,1);
			var ratios:Array = new Array(0,120);
			var type:String = GradientType.RADIAL;

			for (var cur_q = 0; cur_q<max_q && cur_q<nt.length; cur_q++)
			{
				all_q[cur_q] = new Round_button(nt[cur_q],cf1,cf2,cs1,cs2,n,b);
				all_q[cur_q].x = (all_q[cur_q].size*2+dist)*(cur_q)+all_q[cur_q].size;
				this.addChild(all_q[cur_q]);
				all_q[cur_q].addEventListener(MouseEvent.CLICK,choose);
			}
			function choose(ev:MouseEvent)
			{
				if (ch !== ev.currentTarget && ch !== null)
				{
					ch.spr.graphics.clear();
					ch.spr.graphics.beginGradientFill(type,colors,alphas,ratios);
					if (n == 1)
					{
						ch.spr.graphics.lineStyle(4,b);
					}
					ch.spr.graphics.drawCircle(0,0,ch.size);					
				}
				ch = ev.currentTarget;				
			}
		}
	}
}