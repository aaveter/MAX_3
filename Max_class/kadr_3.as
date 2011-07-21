package Max_class
{
	import Max_class.MaxMap;
	import Max_class.MaxMapLoader;
	import Max_class.MaxMiniMap;
	import Main.Zoom_b;
	import Main.Scroll_menu;
	import Main.Game;
	import flash.display.*;
	import flash.net.URLLoader;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.events.Event;

	public class kadr_3 extends Sprite
	{
		var ML:MaxMapLoader = null;
		var scroll_place:Sprite=new Sprite();
		var map_place:Sprite=new Sprite();
		var rect:Rectangle = new Rectangle(0,0,Game.visible_map_x,Game.visible_map_y);
		var map:MaxMap = null;
		var scr:Scroll_menu = null;
		var mini_map:MaxMiniMap = null;
		var Z:Zoom_b = null;

		override public function set width(w:Number):void
		{
			scr.resize_me(Game.visible_map_x,Game.visible_map_y);
			//SL.resize_me(this);
		}

		override public function set height(h:Number):void
		{
			scr.resize_me(Game.visible_map_x,Game.visible_map_y);
			//SL.resize_me(this);
		}

		public function kadr_3(mapObject:MapClass)
		{
			var fon:KadrFon = new KadrFon(Game.doc_x,Game.doc_y);
			addChild(fon);

			//ML = new MaxMapLoader(urlLoaderMap);
			map = new MaxMap(mapObject);
			scroll_place.addChild(map_place);
			map_place.addChild(map);
			scr = new Scroll_menu(scroll_place,map_place,Arrow,bar_box,0x0000FF,2,30,100,Game.visible_map_y,Game.visible_map_x);
			mini_map = new MaxMiniMap(mapObject,200,200,scr.rect);
			Z = new Zoom_b(scr.rect,map_place,map);

			scroll_place.x = 210;
			scroll_place.y = 5;
			addChild(scroll_place);
			addChild(mini_map);
			addChild(Z);
			mini_map.x = 5;
			mini_map.y = 300;
			Z.x = 5;
			Z.y = 5;
			addEventListener(MouseEvent.MOUSE_MOVE,moving);
			addEventListener(MouseEvent.CLICK,replace);
			//SL = new Start_location(this,map_place,mini_map,map,scr);
			function moving(ev:MouseEvent)
			{
				if (ev.buttonDown == true)
				{
					replace(ev);
				}
			}
			function replace(ev:MouseEvent)
			{
				Game.cell_size = Game.cell_pixels / Z.curX;
				scr.scroll_x.box.height = scr.scroll_x.sh * Z.curX;
				scr.scroll_y.box.height = scr.scroll_y.sh * Z.curX;
				scr.scroll_x.replace(scr.rect.x);
				scr.scroll_y.replace(scr.rect.y);
				mini_map.border_mm.width = Game.visible_map_x / Game.cell_size * Game.mini_cs;
				mini_map.border_mm.height = Game.visible_map_y / Game.cell_size * Game.mini_cs;
				mini_map.replace();
			}
		}
	}
}