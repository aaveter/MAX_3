package Max_class
{
	import Main.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.ui.Mouse;
	import Max_class.MaxMiniMap;
	import Max_class.MaxMap;
	import Units.*;
	import flash.text.TextField;

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
			var pl:int = 0;
			str = Game.Players[Game.player].name;
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
					Game.Players[Game.player].sl.x = Math.ceil(map.mouseX / Game.cell_size);
					Game.Players[Game.player].sl.y = Math.ceil(map.mouseY / Game.cell_size);
					for (pl = 0; pl < Game.Players.length; pl++)
					{
						if (Game.player != pl)
						{
							if (Math.abs(Game.Players[Game.player].sl.x - Game.Players[pl].sl.x) <= Game.pd && Math.abs(Game.Players[Game.player].sl.y - Game.Players[pl].sl.y) <= Game.pd)
							{
								str = "Вы выбрали одно место с другим игроком";
								create_error_text();
								Game.Players[Game.player].sl.x = 0;//Использую как переменную для проверки переходим ли к след. игроку.
								Game.Players[Game.player].sl.y = 0;
								break;
							}
						}
					}
					if (Game.Players[Game.player].sl.x != 0)
					{
						for (pl = Game.player; pl < Game.Players.length; pl++)
						{
							if (Game.Players[pl].sl.x == 0)
							{
								break;
							}
						}
						if (pl == Game.Players.length)
						{
							for (pl = 0; pl < Game.player; pl++)
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
				cl.x = (Game.Players[Game.player].sl.x - 0.5) * Game.cell_size;
				cl.y = (Game.Players[Game.player].sl.y - 0.5) * Game.cell_size;
				map.addChild(cl);
				var cl_time:Timer = new Timer(500,1);
				cl_time.start();
				map.removeEventListener(MouseEvent.MOUSE_DOWN,mp_down);
				if (pl != Game.player)
				{
					cl_time.addEventListener(TimerEvent.TIMER_COMPLETE,cl_complete1);
					function cl_complete1(event:TimerEvent)
					{
						map.removeChild(cl);
						Game.player = pl - 1;
						base_position();
						Game.player +=  1;
						str = Game.Players[Game.player]["name"];
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
						while (Game.scan_zone.numChildren != 0)
						{
							Game.scan_zone.removeChildAt(Game.scan_zone.numChildren - 1);
							Game.mini_scan_zone.removeChildAt(Game.mini_scan_zone.numChildren - 1);
						}
						Game.step = 1;
						Game.player = 0;
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
				for (Game.player = 0; Game.player < Game.Players.length; Game.player++)
				{
					Game.Players[Game.player].units[0] = new ingener  ;
					Game.Players[Game.player].units[0].create_unit(m,mini_map,Game.Players[Game.player].sl.x,Game.Players[Game.player].sl.y,Game.Players[Game.player].color,Game.mini_cs);
					Game.Players[Game.player].units[1] = new construct  ;
					Game.Players[Game.player].units[1].create_unit(m,mini_map,Game.Players[Game.player].sl.x + 1,Game.Players[Game.player].sl.y,Game.Players[Game.player].color,Game.mini_cs);
					Game.Players[Game.player].units[2] = new scout  ;
					Game.Players[Game.player].units[2].create_unit(m,mini_map,Game.Players[Game.player].sl.x + 1,Game.Players[Game.player].sl.y + 1,Game.Players[Game.player].color,Game.mini_cs);
				}
				var NSB:Button_press = new Button_press(Formats.Static,"Следующий ход");//Кнопка для следующего хода
				kadr.addChild(NSB);
				NSB.x = 5;
				NSB.y = 120;
				NSB.addEventListener(MouseEvent.CLICK,NSB_func);
				function NSB_func(ev:MouseEvent)
				{
					for (var i = 0; i<Game.Players[Game.player].units.length; i++)
					{
						Game.Players[Game.player].units[i].deselect();
					}
					Game.player +=  1;
					if (Game.player == Game.Players.length)
					{
						Game.step +=  1;
						Game.player = 0;
					}
					next_step();
				}
				Game.unit_TF.x = 5;
				Game.unit_TF.y = 190;
				kadr.addChild(Game.unit_TF);
			}

			//Функция по выводу текста с номером хода и именем ходящего игрока;
			function next_step()
			{
				str = "Ход " + Game.step + " " + Game.Players[Game.player].name;
				base_position();
				next_player();
				//Удаляю предидущую зону сканирования
				while (Game.scan_zone.numChildren != 0)
				{
					Game.scan_zone.removeChildAt(Game.scan_zone.numChildren - 1);
					Game.mini_scan_zone.removeChildAt(Game.mini_scan_zone.numChildren - 1);
				}
				BP.addEventListener(MouseEvent.CLICK,next_zone);
			}
			function next_zone(event:MouseEvent)
			{
				base_position(Game.Players[Game.player].sl.x,Game.Players[Game.player].sl.y);
				//Теперь перебираем сканы всех юнитов и создаем области видимости с помощью mask;
				for (var pu = 0; pu < Game.Players[Game.player].units.length; pu++)
				{
					Game.scan_zone.addChild(Game.Players[Game.player].units[pu].scan_area);
					Game.mini_scan_zone.addChild(Game.Players[Game.player].units[pu].mini_scan_area);
					Game.Players[Game.player].units[pu].cur_speed +=  Game.Players[Game.player].units[pu].speed;
					if (Game.Players[Game.player].units[pu].cur_speed > Game.Players[Game.player].units[pu].speed)
					{
						Game.Players[Game.player].units[pu].cur_speed = Game.Players[Game.player].units[pu].speed;
					}
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
			//переношу карту в начальную позицию для выбора
			function base_position(xx:int=0,yy:int=0)
			{
				if (xx * Game.cell_size - Game.visible_map_x / 2 < 0)
				{
					xx = 0;
				}
				else
				{
					xx = xx * Game.cell_size - Game.visible_map_x / 2;
				}
				if (yy * Game.cell_size - Game.visible_map_y / 2 < 0)
				{
					yy = 0;
				}
				else
				{
					yy = yy * Game.cell_size - Game.visible_map_y / 2;
				}

				scr.rect.x = xx;
				scr.rect.y = yy;
				map.scrollRect = scr.rect;
				mini_map.replace();
				scr.scroll_x.replace(scr.rect.x);
				scr.scroll_y.replace(scr.rect.y);
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