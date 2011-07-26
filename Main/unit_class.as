package Main
{
	import flash.display.*;
	import Main.Game;
	import Max_class.MaxMap;
	import Max_class.MaxMiniMap;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	import fl.transitions.Rotate;

	public class unit_class extends Sprite
	{
		public var bmp:MovieClip;//Картинка как выглядит юнит
		public var unit_name:String;//Наименование юнита
		public var hp:Number;//Кол-во жизней юнита
		public var armor:Number;//Броня юнита уменьшает наносимый урон
		public var speed:Number = 0;//Скорость юнита
		public var power:Number = 0;//Наносимый урон
		public var shots:Number = 0;//Количество выстрелов за ход
		public var type_move:String = "0";//Вид передвижения юнита 1 - по земле, 2 - по воздуху, 3 - по воде, 
		//4 - под водой, 5 - по горам, 0 - не двигается
		public var type_attack:String = "0";//Тип атаки юнита.1 - по наземным, 2 - по воздушным, 3 - по водным,
		//4 - по подводным, 0 - нипокому
		public var ammo:Number = 0;//Количество патронов
		public var cost:Number;//Стоимость постройки в ресурсах, отсюда же стоимость покупки береться и длительность строительства.
		public var range:Number = 0;//Дальность выстрела
		public var scan:Number;//Видимая зона вокруг юнита
		public var build:String = "false";//Параметр показывает строит ли юнит здания. (true or false)
		var cur_hp:Number,max_hp:Number;//Текущее и максимальное кол-во жизней
		public var gor:Number = 0,vert:Number = 0;//Горизонтальное и вертикальное положение юнита на карте
		public var scan_area:Sprite = new Sprite  ;
		public var mini_scan_area:Sprite = new Sprite  ;
		public var mini_bmp:Sprite = new Sprite  ;
		var target_x:Number=new Number();//Точка, в которую должен переместиться юнит
		var target_y:Number=new Number();//Точка, в которую должен переместиться юнит
		var point_x:Number=new Number();//Временная точка, используется для проверки что мы второй раз ткунли туда же.
		var point_y:Number=new Number();//Временная точка, используется для проверки что мы второй раз ткунли туда же.
		var path:Sprite =new Sprite();//Здесь рисуем маршрут по которому пойдет юнит

		public function unit_class()
		{
		}

		public function create_unit(m:MaxMap,mm:MaxMiniMap,g,v,color,mini_cs=4)
		{
			m.addChild(path);
			mini_bmp.graphics.beginFill(color);
			mini_bmp.graphics.drawRect(0,0,mini_cs,mini_cs);
			scan_area.graphics.beginFill(0x000099);
			mini_scan_area.graphics.beginFill(0x000099);
			scan_area.graphics.drawCircle(0,0,scan*Game.cell_pixels);
			mini_scan_area.graphics.drawCircle(0,0,scan*mini_cs);
			gor = g;
			vert = v;
			m.map_units.addChild(this);
			mm.mini_map_units.addChild(mini_bmp);
			Game.scan_zone.addChild(scan_area);
			Game.mini_scan_zone.addChild(mini_scan_area);
			place();
			addEventListener(MouseEvent.MOUSE_DOWN,select_down);
			function place()
			{
				x=(gor-0.5)*Game.cell_pixels;
				y=(vert-0.5)*Game.cell_pixels;
				mini_bmp.x = (gor-1) * mini_cs;
				mini_bmp.y = (vert-1) * mini_cs;
				scan_area.x = x;
				scan_area.y = y;
				mini_scan_area.x = x / Game.cell_pixels * Game.mini_cs;
				mini_scan_area.y = y / Game.cell_pixels * Game.mini_cs;
			}
			function select_down(ev:MouseEvent)
			{
				var time:Timer = new Timer(200,1);
				time.start();
				time.addEventListener(TimerEvent.TIMER_COMPLETE,compl);
				addEventListener(MouseEvent.MOUSE_UP,select_up);
				function compl(ev:TimerEvent)
				{
					removeEventListener(MouseEvent.MOUSE_UP,select_up);
				}
			}
			function select_up(ev:MouseEvent)
			{
				var time:Timer = new Timer(1,1);
				time.start();
				time.addEventListener(TimerEvent.TIMER_COMPLETE,compl);
				function compl(ev:TimerEvent)
				{
					graphics.lineStyle(2,0x000000);
					graphics.drawCircle(0,0,50);
					m.addEventListener(MouseEvent.MOUSE_DOWN,map_down);
				}
			}
			function map_down(ev:MouseEvent)
			{
				var time:Timer = new Timer(200,1);
				time.start();
				time.addEventListener(TimerEvent.TIMER_COMPLETE,compl);
				m.addEventListener(MouseEvent.MOUSE_UP,deselect);
				m.addEventListener(MouseEvent.MOUSE_UP,moving);
				function compl(ev:TimerEvent)
				{
					m.removeEventListener(MouseEvent.MOUSE_UP,deselect);
					m.removeEventListener(MouseEvent.MOUSE_UP,moving);
				}
			}
			function moving(ev:MouseEvent)
			{
				if (target_x == 0 && ev.target.constructor == Sprite)
				{
					target_x = Math.ceil(ev.currentTarget.mouseX / Game.cell_pixels);
					target_y = Math.ceil(ev.currentTarget.mouseY / Game.cell_pixels);
					create_path();
					trace("choose",target_x,target_y);
				}
				else if (target_x != 0 && ev.target.constructor == Sprite)
				{
					path.graphics.clear();
					point_x = Math.ceil(ev.currentTarget.mouseX / Game.cell_pixels);
					point_y = Math.ceil(ev.currentTarget.mouseY / Game.cell_pixels);
					if (target_x == point_x && target_y == point_y)
					{
						trace("place");
						//gor = Math.ceil(ev.currentTarget.mouseX / Game.cell_pixels);
						//vert = Math.ceil(ev.currentTarget.mouseY / Game.cell_pixels);
						create_move();
					}
					else if (target_x != point_x || target_y != point_y)
					{
						trace("=point");
						target_x = point_x;
						target_y = point_y;
						create_path();
					}
				}
			}
			function deselect(ev:MouseEvent)
			{
				if (ev.ctrlKey == false && ev.target.constructor != Sprite)
				{
					m.removeEventListener(MouseEvent.MOUSE_DOWN,map_down);
					graphics.clear();
					path.graphics.clear();
					target_x = 0;
					target_y = 0;
					point_x = 0;
					point_y = 0;
				}
			}
			function create_move()
			{
				var xx:int = Math.abs(target_x - gor);
				var yy:int = Math.abs(target_y - vert);
				var side_x:int = 1;
				var side_y:int = 1;
				if (target_x - gor < 0)
				{
					side_x = -1;
				}
				if (target_y - vert < 0)
				{
					side_y = -1;
				}
				//var time:Timer = new Timer(200,Math.max(xx,yy));
				//var time_delay:int = 0;
				//time.start();
				//time.addEventListener(TimerEvent.TIMER,timing);
				//function timing(ev:TimerEvent)
				//{
				//for_place()
				//place();
				//}
				for_place();
				function for_place()
				{
					var i:int = 0;
					var j:int = 0;
					var rot_st:Number = rotation;//Состояние повернутости на начала поворота
					var rot_fin:Number;//Состояние повернутости на конец поворота
					if (xx >= yy * 2)
					{
						xx -=  1;
						gor +=  1 * side_x;
						rot_fin = 90 * side_x;
					}
					else if (xx*2 <= yy)
					{
						yy -=  1;
						vert +=  1 * side_y;
						rot_fin = 90 + 90 * side_y;
					}
					else
					{
						xx -=  1;
						yy -=  1;
						rot_fin = 45 + 45 * side_x + 45 * side_y;
						if (side_y == 1 && side_x == -1)
						{
							rot_fin +=  180;
						}
						gor +=  1 * side_x;
						vert +=  1 * side_y;
					}
					var times:int = Math.abs(rot_fin - rot_st) / 5;
					var side:int = 1;
					if (rot_fin < rot_st)
					{
						side = -1;
					}
					if (times != 0)
					{
						trace(times);
						var time:Timer = new Timer(10,times);
						var timer:int = 0;
						time.start();
						time.addEventListener(TimerEvent.TIMER,timing);
						function timing(ev:TimerEvent)
						{
							rotation +=  5 * side;
							timer +=  1;
							if (timer == times)
							{
								place();
								if (gor != target_x || vert != target_y)
								{									
									for_place();
								}								
							}
						}
					}
					else
					{
						place();
						if (gor != target_x || vert != target_y)
						{							
							for_place();
						}
					}
				}
			}
			function create_path()
			{
				var xx:int = Math.abs(target_x - gor);
				var yy:int = Math.abs(target_y - vert);
				var side_x:int = 1;
				var side_y:int = 1;
				if (target_x - gor < 0)
				{
					side_x = -1;
				}
				if (target_y - vert < 0)
				{
					side_y = -1;
				}
				path.graphics.beginFill(color,1);

				for (var i=0,j=0; i<xx || j<yy; )
				{
					if (xx - i >= (yy-j) * 2)
					{
						i +=  1;
					}
					else if ((xx-i)*2 <= yy-j)
					{
						j +=  1;
					}
					else
					{
						i +=  1;
						j +=  1;
					}
					path.graphics.drawCircle((i*side_x+gor-0.5)*Game.cell_pixels,(j*side_y+vert-0.5)*Game.cell_pixels,10);
				}
				path.graphics.drawCircle((target_x-0.5)*Game.cell_pixels,(target_y-0.5)*Game.cell_pixels,20);
			}
		}
	}
}