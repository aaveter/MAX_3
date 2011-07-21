package Max_class
{
	import Main.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.ui.Mouse;
	import Max_class.MaxMiniMap;
	import Max_class.MaxMap
	import Units.*

	public class Start_location
	{
		public var mc:Sprite = new cursor_class  ;
		public var Sh:shadow = null;
		public var TB:text_block = null;
		var str:String=new String();// сюда заносим текст для создания кнопки или ошибки
		public var BP:Button_press = null;
		//map - карта с которой будем работать
		public function Start_location(kadr:Sprite,map:Sprite,mini_map:MaxMiniMap,m:MaxMap,scr:Scroll_menu)
		{
			//Создаем затенение на все и кнопку с текстом кто выбирает локацию.
			var player:int = 0;
			var pl:int = 0;
			str = Game.Players[player].name;
			next_player();
			map.addEventListener(MouseEvent.MOUSE_DOWN,mp_down);
			mc.mouseEnabled = false;
			map.addEventListener(MouseEvent.MOUSE_OVER,cursor_add);			
			function next_player()
			{
				BP = new Button_press(Formats.Static,str);
				Sh = new shadow(kadr);
				Sh.width = Game.doc_x;
				Sh.height = Game.doc_y;
				kadr.addChild(BP);
				BP.replace(Game.stage_);
				BP.addEventListener(MouseEvent.CLICK,bp_click);
				function bp_click(event:MouseEvent)
				{
					kadr.removeChild(BP);
					kadr.removeChild(Sh);
					BP.removeEventListener(MouseEvent.CLICK,bp_click);					
				}
			}

			//Функция клика мышью при выборе места старта (непосредственно нажатие клавиши мыши)
			function mp_down(event:MouseEvent)
			{
				var mpd_time:Timer = new Timer(200,1);
				map.addEventListener(MouseEvent.MOUSE_UP,mp_up);
				mpd_time.start();
				mpd_time.addEventListener(TimerEvent.TIMER_COMPLETE,mpd_complete);
				function mpd_complete(event:TimerEvent)
				{
					map.removeEventListener(MouseEvent.MOUSE_UP,mp_up);
				}
			}

			//Функция клика мышью при выборе места старта (непосредственно отпускание клавиши мыши)
			function mp_up(event:MouseEvent)
			{
				map.removeEventListener(MouseEvent.MOUSE_UP,mp_up);
				if (Math.ceil(map.mouseX / Game.cell_size) > Game.pd &&
				Math.ceil(map.mouseX / Game.cell_size) < map.width - Game.pd &&
				Math.ceil(map.mouseY / Game.cell_size) > Game.pd &&
				Math.ceil(map.mouseY / Game.cell_size) < map.height - Game.pd)
				{
					Game.Players[player].sl.x = Math.ceil(map.mouseX / Game.cell_size);
					Game.Players[player].sl.y = Math.ceil(map.mouseY / Game.cell_size);
					for (pl = 0; pl < Game.Players.length; pl++)
					{
						if (player != pl)
						{
							if (Math.abs(Game.Players[player].sl.x - Game.Players[pl].sl.x) <= Game.pd && Math.abs(Game.Players[player].sl.y - Game.Players[pl].sl.y) <= Game.pd)
							{
								str = "Вы выбрали одно место с другим игроком";
								create_error_text();
								Game.Players[player].sl.x = 0;//Использую как переменную для проверки переходим ли к след. игроку.
								Game.Players[player].sl.y = 0;
								break;
							}
						}
					}
					if (Game.Players[player].sl.x != 0)
					{
						for (pl = player; pl < Game.Players.length; pl++)
						{
							if (Game.Players[pl].sl.x == 0)
							{
								break;
							}
						}
						if (pl == Game.Players.length)
						{
							for (pl = 0; pl < player; pl++)
							{
								if (Game.Players[pl].sl.x == 0)
								{
									break;
								}
							}
						}
						create_cl();
					}
				}
				else
				{
					str = "Слишком близко к краю";
					create_error_text();
				}
			}

			//Функция выбора места старта и перехода к следующему игроку
			function create_cl()
			{
				var cl:MovieClip = new round_class  ;
				cl.width = Game.cell_size;
				cl.height = Game.cell_size;
				cl.x = (Game.Players[player].sl.x - 0.5) * Game.cell_size;
				cl.y = (Game.Players[player].sl.y - 0.5) * Game.cell_size;
				map.addChild(cl);
				var cl_time:Timer = new Timer(500,1);
				cl_time.start();
				map.removeEventListener(MouseEvent.MOUSE_DOWN,mp_down);
				if (pl != player)
				{
					cl_time.addEventListener(TimerEvent.TIMER_COMPLETE,cl_complete1);
					function cl_complete1(event:TimerEvent)
					{
						map.removeChild(cl);
						player = pl - 1;
						//переношу карту в начальную позицию для выбора
						scr.rect.x = 0;
						scr.rect.y = 0;
						map.scrollRect = scr.rect;
						mini_map.replace();
						scr.scroll_x.replace(scr.rect.x);
						scr.scroll_y.replace(scr.rect.y);
						//Конец переноса;
						player +=  1;
						str = Game.Players[player]["name"];
						next_player();
						map.addEventListener(MouseEvent.MOUSE_DOWN,mp_down);
					}
				}
				else
				{
					cl_time.addEventListener(TimerEvent.TIMER_COMPLETE,cl_complete2);
					function cl_complete2(event:TimerEvent)
					{
						map.removeChild(cl);
						Mouse.show();
						map.removeChild(mc);
						map.removeEventListener(MouseEvent.MOUSE_MOVE,cursor_move);
						map.removeEventListener(MouseEvent.MOUSE_OUT,cursor_del);
						map.removeEventListener(MouseEvent.MOUSE_OVER,cursor_add);
						create_start_situation();
						Game.step = 1;
						player = 0;
						next_step();
					}
				}
			}

			//Создаем начальную ситуацию на карте по заданным условиям
			function create_start_situation()
			{
				m.map_units.addChild(Game.scan_zone);
				mini_map.mini_map_units.addChild(Game.mini_scan_zone);
				m.map_units.mask = Game.scan_zone;
				mini_map.mini_map_units.mask = Game.mini_scan_zone;
				for (player = 0; player < Game.Players.length; player++)
				{
					Game.Players[player].units[0] = new ingener  ;
					Game.Players[player].units[0].create_unit(m.map_units,mini_map.mini_map_units,Game.Players[player].sl.x,Game.Players[player].sl.y,Game.Players[player].color,Game.cell_pixels,Game.mini_cs);
					Game.Players[player].units[1] = new construct  ;
					Game.Players[player].units[1].create_unit(m.map_units,mini_map.mini_map_units,Game.Players[player].sl.x + 1,Game.Players[player].sl.y,Game.Players[player].color,Game.cell_pixels,Game.mini_cs);
					Game.Players[player].units[2] = new scout  ;
					Game.Players[player].units[2].create_unit(m.map_units,mini_map.mini_map_units,Game.Players[player].sl.x + 1,Game.Players[player].sl.y + 1,Game.Players[player].color,Game.cell_pixels,Game.mini_cs);
				}
			}

			//Функция по выводу текста с номером хода и именем ходящего игрока;
			function next_step()
			{
				str = "Ход " + Game.step + " " + Game.Players[player].name;
				next_player()
				BP.addEventListener(MouseEvent.CLICK,next_zone);
			}
			function next_zone(event:MouseEvent)
			{
				//Удаляю предидущую зону сканирования
				while (Game.scan_zone.numChildren != 0)
				{
					Game.scan_zone.removeChildAt(Game.scan_zone.numChildren - 1);
					Game.mini_scan_zone.removeChildAt(Game.mini_scan_zone.numChildren - 1);
				}
				//Теперь перебираем сканы всех юнитов и создаем области видимости с помощью mask;
				for (var pu = 0; pu < Game.Players[player].units.length; pu++)
				{
					Game.scan_area[pu] = new Sprite  ;
					Game.mini_scan_area[pu] = new Sprite  ;
					Game.scan_area[pu].graphics.clear();
					Game.mini_scan_area[pu].graphics.clear();
					var xx:int = (Game.Players[player].units[pu].gor - 0.5) * Game.cell_pixels;
					var yy:int = (Game.Players[player].units[pu].vert - 0.5) * Game.cell_pixels;					
					var mini_xx:int = (Game.Players[player].units[pu].gor - 0.5) * Game.mini_cs;
					var mini_yy:int = (Game.Players[player].units[pu].vert - 0.5) * Game.mini_cs;
					var scan:int = Game.Players[player].units[pu].scan * Game.cell_pixels;
					var mini_scan:int = Game.Players[player].units[pu].scan * Game.mini_cs;
					Game.scan_area[pu].graphics.beginFill(0x000099);
					Game.mini_scan_area[pu].graphics.beginFill(0x000099);
					Game.scan_area[pu].graphics.drawCircle(xx,yy,scan);
					Game.mini_scan_area[pu].graphics.drawCircle(mini_xx,mini_yy,mini_scan);
					Game.scan_zone.addChild(Game.scan_area[pu]);
					Game.mini_scan_zone.addChild(Game.mini_scan_area[pu]);
				}
			}
			//Функция по выводу на экран текста с ошибкой
			function create_error_text()
			{
				Sh = new shadow(kadr);
				Sh.width = Game.doc_x;
				Sh.height = Game.doc_y;
				TB = new text_block(kadr,str,Formats.Static);
				TB.addEventListener(MouseEvent.CLICK,error_accept);
				function error_accept(event:MouseEvent)
				{
					TB.removeEventListener(MouseEvent.CLICK,error_accept);
					kadr.removeChild(TB);
					kadr.removeChild(Sh);
				}
			}

			function cursor_add(ev:MouseEvent)
			{
				Mouse.hide();
				map.addChild(mc);
				mc.x = map.mouseX;
				mc.y = map.mouseY;
				map.addEventListener(MouseEvent.MOUSE_MOVE,cursor_move);
				map.addEventListener(MouseEvent.MOUSE_OUT,cursor_del);
			}
			function cursor_move(ev:MouseEvent)
			{
				mc.x = map.mouseX;
				mc.y = map.mouseY;
			}
			function cursor_del(ev:MouseEvent)
			{
				Mouse.show();
				map.removeChild(mc);
				map.removeEventListener(MouseEvent.MOUSE_MOVE,cursor_move);
				map.removeEventListener(MouseEvent.MOUSE_OUT,cursor_del);
			}
		}
		public function resize_me(kadr)
		{
			Sh.width = Game.doc_x;
			Sh.height = Game.doc_y;
			if (TB != null)
			{
				TB.replace(Game.stage_);
			}
			if (BP != null)
			{
				BP.replace(Game.stage_);
			}
		}
	}
}