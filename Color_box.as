package Main
{
	import flash.display.*;
	import flash.events.*;

	public class Color_box extends Sprite
	{
		public var color:uint;
		public function Color_box(c:uint,w:int,h:int,colors:Array,l:Number=20)
		{
			var col_change:Sprite=new Sprite();
			var back:Sprite=new Sprite();
			color = c;
			this.graphics.beginFill(c);
			this.graphics.drawRect(0,0,w,h);
			this.addEventListener(MouseEvent.MOUSE_OVER,over);
			this.addEventListener(MouseEvent.ROLL_OUT,out);
			col_change.addEventListener(MouseEvent.CLICK,cl);
			function over()
			{
				col_change.x = w + l / 2;
				back.x = w;
				for (var i = 0; i<colors.length; i++)
				{
					var xx = l * i;
					col_change.graphics.beginFill(colors[i]);
					col_change.graphics.drawRect(xx,0,l,l);
				}
				back.graphics.beginFill(c,0);
				back.graphics.drawRect(0,0,col_change.width+l/2,h);
				addChild(back);
				addChild(col_change);				
			}
			function out()
			{
				removeChild(col_change);		
				removeChild(back);		
			}
			function cl(ev:MouseEvent)
			{
				var n:int = Math.floor(ev.currentTarget.mouseX / l);				
				color = colors[n];
				graphics.clear();
				graphics.beginFill(color);
				graphics.drawRect(0,0,w,h);
			}
		}
	}
}