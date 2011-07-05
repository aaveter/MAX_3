package Max_class
{
	import Max_class.MaxMap;
	import Max_class.MaxMapLoader;
	import Max_class.MaxMiniMap;
	import Main.Zoom_b;
	import Main.Scroll_menu;
	import Main.Game;
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse

	public class kadr_3 extends Sprite
	{
		public function kadr_3(urlLoaderMap:URLLoader)
		{
			var ML:MaxMapLoader = new MaxMapLoader(urlLoaderMap);
			var scroll_place:Sprite=new Sprite();
			var map_place:Sprite=new Sprite();
			var rect:Rectangle = new Rectangle(0,0,Game.visible_map_x,Game.visible_map_y);
			var map:MaxMap = new MaxMap(ML.map_size,ML.cell);
			scroll_place.addChild(map_place);
			map_place.addChild(map);
			var scr:Scroll_menu = new Scroll_menu(scroll_place,map_place,Arrow,bar_box,0x0000FF,2,50,100,Game.visible_map_y,Game.visible_map_x);
			var mini_map:MaxMiniMap = new MaxMiniMap(ML.map_size,ML.cell,200,200,scr.rect);
			var Zoom:Zoom_b = new Zoom_b(scr.rect,map_place,map);
			scroll_place.x = 210;
			scroll_place.y = 5;
			addChild(scroll_place);
			addChild(mini_map);
			addChild(Zoom);
			mini_map.x = 5;
			mini_map.y = 300;
			Zoom.x = 5;
			Zoom.y = 5;
			addEventListener(MouseEvent.MOUSE_MOVE,moving);
			addEventListener(MouseEvent.CLICK,replace);
			map.addEventListener(MouseEvent.MOUSE_DOWN,replace_map);

			function moving(ev:MouseEvent)
			{
				if (ev.buttonDown == true)
				{
					replace(ev);
				}
			}
			function replace(ev:MouseEvent)
			{
				scr.scroll_x.replace(scr.rect.x);
				scr.scroll_y.replace(scr.rect.y);
				mini_map.replace();
			}			
		}
	}
}