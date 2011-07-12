package Main
{
	import flash.display.*;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Round_button extends Sprite
	{
		public var size:Number = 30;
		public var spr:Sprite= new Sprite();
		public var txt:TextField = new TextField();

		//t - текст который будет на кнопке
		//cf1, cf2 - цвета для градиента в не нажатом режиме
		//cs1, cs2 - цвета для градиента в нажатом режиме
		//n - 0 - нет границы, 1 - есть граница
		//b - цвет границы
		//bm - указывает на то есть ли мувик на кнопке 1 - есть, 0 -нету
		public function Round_button(t:String="",cf1:uint=0x0000FF,cf2:uint=0x00FF99,cs1:uint=0xFF0000,cs2:uint=0x00FF99,n:Number=1,b:uint=0x000000,bm:Number=1)
		{
			var colors:Array = new Array(cf1,cf2);
			var alphas:Array = new Array(1,1);
			var ratios:Array = new Array(0,120);
			var type:String = GradientType.RADIAL;

			txt.text = t;
			txt.setTextFormat(Formats.Title);
			txt.mouseEnabled = false;
			txt.width = size;
			txt.height = size * 2;
			txt.x =  -  size / 2;
			txt.y =  -  size;
			this.addChild(spr);
			this.addChild(txt);
			spr.graphics.beginGradientFill(type,colors,alphas,ratios);
			if (n == 1)
			{
				spr.graphics.lineStyle(4,b);
			}
			spr.graphics.drawCircle(0,0,size);
			addEventListener(MouseEvent.CLICK,press_b);			

			function press_b(ev:MouseEvent)
			{
				colors = new Array(cs1,cs2);
				spr.graphics.clear();
				spr.graphics.beginGradientFill(type,colors,alphas,ratios);
				if (n == 1)
				{
					spr.graphics.lineStyle(4,b);
				}
				spr.graphics.drawCircle(0,0,size);
			}
			if (bm == 1)
			{
				addEventListener(MouseEvent.ROLL_OVER,over);
				var time:Timer = new Timer(20);
				var graf:Sprite=new Sprite();
				var size_time:Number = size;
				var i:Number = 0.5;
				var a:Number = 0.3;
				function over(ev:MouseEvent)
				{
					graf.graphics.beginFill(0xFFFFFF,a);
					graf.graphics.drawCircle(0,0,size);
					addChild(graf);
					time.addEventListener("timer",moving);
					time.start();
					addEventListener(MouseEvent.ROLL_OUT,out);
					function moving(ev:TimerEvent)
					{
						new_size();
					}
					function new_size()
					{						
						size_time -=  i;
						graf.graphics.clear();
						graf.graphics.beginFill(0xFFFFFF,a);
						graf.graphics.drawCircle(0,0,size_time);
						if (size_time <= i)
						{
							size_time = size;
							graf.graphics.clear();
							graf.graphics.beginFill(0xFFFFFF,a);
							graf.graphics.drawCircle(0,0,size_time);
						}
					}
					function out(ev:MouseEvent)
					{						
						graf.graphics.clear();
						time.stop();
						time.removeEventListener(TimerEvent.TIMER,moving);
						spr.removeEventListener(MouseEvent.MOUSE_OUT,out);
					}
				}
			}
		}
	}
}