package Max_class
{
	import Main.Game;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.events.*;

	public class MaxMiniMap extends Sprite
	{
		var mini_map:Sprite=new Sprite();
		var mini_map_units:Sprite=new Sprite();
		public var border_mm:Sprite = new border_class  ;
		var rect:Rectangle

		//map_size - размер карты
		//cell - массив всех клеток карты
		//w - размер мини карты по X
		//h - размер мини карты по Y
		//r - видимая часть карты (используется для прокрутки карты через мини)
		public function MaxMiniMap(mapObject:MapClass,w:Number=200,h:Number=200,r:Rectangle=null)
		{
			addChild(mini_map_units);
			addChild(mini_map);
			addChild(border_mm);
			
			rect = r;
			
			mapObject.draw(mini_map, Game.mini_cs);
			
			border_mm.width = Game.visible_map_x / Game.cell_size * Game.mini_cs;
			border_mm.height = Game.visible_map_y / Game.cell_size * Game.mini_cs;
			width = w;
			height = h;

			//Передвижение по мини-карте
			this.addEventListener(MouseEvent.CLICK,replace);
			this.addEventListener(MouseEvent.MOUSE_MOVE,moving);
			function replace(ev:MouseEvent)
			{
				border_mm.x = ev.target.mouseX - border_mm.width / 2;
				border_mm.y = ev.target.mouseY - border_mm.height / 2;
				if (border_mm.x < 0)
				{
					border_mm.x = 0;
				}
				if (border_mm.x > mini_map.width - border_mm.width)
				{
					border_mm.x = mini_map.width - border_mm.width;
				}
				if (border_mm.y < 0)
				{
					border_mm.y = 0;
				}
				if (border_mm.y > mini_map.height - border_mm.height)
				{
					border_mm.y = mini_map.height - border_mm.height;
				}
				if (rect != null)
				{
					rect.x = border_mm.x / Game.mini_cs * Game.cell_size;
					rect.y = border_mm.y/Game.mini_cs*Game.cell_size;
				}
			}
			function moving(ev:MouseEvent)
			{
				if (ev.buttonDown == true)
				{
					replace(ev);
				}
			}
		}
		public function replace()
		{
			border_mm.x = rect.x/Game.cell_size*Game.mini_cs
			border_mm.y = rect.y/Game.cell_size*Game.mini_cs
		}
	}
}