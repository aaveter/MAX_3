package Max_class
{
	import Max_class.MaxMap;
	import Max_class.MaxMapLoader;
	import Max_class.MaxMiniMap;
	import Main.Zoom_b;
	import Main.Scroll_menu;
	import Main.Game;
	import flash.display.*
	import flash.net.URLLoader;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;

	public class kadr_3 extends Sprite
	{
		public function kadr_3(urlLoaderMap:URLLoader)
		{
			var ML:MaxMapLoader = new MaxMapLoader(urlLoaderMap);
			var scroll_place:Sprite=new Sprite();
			var map_place:Sprite=new Sprite();
			var rect:Rectangle = new Rectangle(0,0,Game.visible_map_x,Game.visible_map_y);
			
			var visible_map:Number=Game.visible_map_x
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
			//map_place.addEventListener(MouseEvent.MOUSE_DOWN,map_down);
//			function map_down(event:MouseEvent)
//			{				
//				var mouse_x = mouseX;
//				var mouse_y = mouseY;
//				map_place.addEventListener(MouseEvent.MOUSE_MOVE,map_move);
//				function map_move(event:MouseEvent)
//				{					
//					if (scr.rect.x+(mouse_x-mouseX)<0)
//					{
//						trace(1)
//						rect.x = 0;
//					}
//					else if (scr.rect.x+(mouse_x-mouseX)>map.width-visible_map)
//					{
//						trace(2)
//						scr.rect.x = map.width - visible_map;
//					}
//					else
//					{
//						trace(3)
//						scr.rect.x+=(mouse_x-mouseX);
//					}
//					mouse_x = mouseX;
//
//					if (scr.rect.y+(mouse_y-mouseY)<0)
//					{
//						scr.rect.y = 0;
//					}
//					else if (scr.rect.y+(mouse_y-mouseY)>map.height-visible_map)
//					{
//						scr.rect.y = map.height - visible_map;
//					}
//					else
//					{
//						scr.rect.y+=(mouse_y-mouseY);
//					}
//					mouse_y = mouseY;
//
//					map_place.scrollRect =scr.rect;
//				}
//				map_place.addEventListener(MouseEvent.MOUSE_UP,map_stop);
//				map_place.addEventListener(MouseEvent.ROLL_OUT,map_stop);
//				function map_stop(event:MouseEvent)
//				{
//					map_place.removeEventListener(MouseEvent.MOUSE_MOVE,map_move);
//					map_place.removeEventListener(MouseEvent.MOUSE_UP,map_stop);
//					map_place.removeEventListener(MouseEvent.ROLL_OUT,map_stop);
//				}
//			}
		}
	}
}