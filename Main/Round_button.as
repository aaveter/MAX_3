package Main
{
	import flash.display.*;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.events.MouseEvent;

	public class Round_button extends Sprite
	{
		public var size:Number = 30;
		public var spr:Sprite= new Sprite();
		public var txt:TextField = new TextField();

		public function Round_button(t:String="",cf1:uint=0x0000FF,cf2:uint=0x00FF99,cs1:uint=0xFF0000,cs2:uint=0x00FF99,n:Number=1,b:uint=0x000000)
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
			txt.x =  -  size/2
			txt.y =  -  size;
			this.addChild(spr);
			this.addChild(txt);
			spr.graphics.beginGradientFill(type,colors,alphas,ratios);
			if (n == 1)
			{
				spr.graphics.lineStyle(4,b);
			}
			spr.graphics.drawCircle(0,0,size);
			this.addEventListener(MouseEvent.CLICK,press_b);

			function press_b()
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
		}
	}
}