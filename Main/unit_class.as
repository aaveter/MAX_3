package Main
{
	import flash.display.*;
	import Main.Game;
	import Max_class.MaxMap;
	import Max_class.MaxMiniMap;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;

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
		var target_cell:Point = null;//Точка, в которую должен переместиться юнит
		var point:Point = null //Временная точка, используется для проверки что мы второй раз ткунли туда же.

		public function unit_class()
		{
		}

		public function create_unit(m:MaxMap,mm:MaxMiniMap,g,v,color,mini_cs=4)
		{
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
				var time:Timer = new Timer(100,1);
				time.start();
				time.addEventListener(TimerEvent.TIMER_COMPLETE,compl);
				addEventListener(MouseEvent.MOUSE_UP,select_up);
				function compl(event:TimerEvent)
				{
					removeEventListener(MouseEvent.MOUSE_UP,select_up);
				}
			}
			function select_up(ev:MouseEvent)
			{
				//var time:Timer = new Timer(100,1);
//				time.start();
//				time.addEventListener(TimerEvent.TIMER_COMPLETE,compl);
//				function compl(event:TimerEvent)
//				{					
					graphics.lineStyle(2,0x000000);
					graphics.drawCircle(0,0,50);
					m.addEventListener(MouseEvent.MOUSE_DOWN,map_down);
				//}
			}
			function map_down(ev:MouseEvent)
			{
				var time:Timer = new Timer(100,1);
				time.start();
				time.addEventListener(TimerEvent.TIMER_COMPLETE,compl);
				m.addEventListener(MouseEvent.MOUSE_UP,moving);
				m.addEventListener(MouseEvent.MOUSE_UP,deselect);
				function compl(event:TimerEvent)
				{
					m.removeEventListener(MouseEvent.MOUSE_UP,moving);
					m.removeEventListener(MouseEvent.MOUSE_UP,deselect);
				}
			}
			function moving(ev:MouseEvent)
			{
				if (target_cell == null && ev.target.constructor == Sprite)
				{
					target_cell=new Point(Math.ceil(ev.currentTarget.mouseX / Game.cell_pixels),
										  Math.ceil(ev.currentTarget.mouseY / Game.cell_pixels))					
					trace("choose",target_cell)
				}
				else if (target_cell != null && ev.target.constructor == Sprite)
				{
					point=new Point(Math.ceil(ev.currentTarget.mouseX / Game.cell_pixels),
					  Math.ceil(ev.currentTarget.mouseY / Game.cell_pixels));
					if (target_cell.x == point.x && target_cell.y == point.y)
					{
						trace("place")
						gor = Math.ceil(ev.currentTarget.mouseX / Game.cell_pixels);
						vert = Math.ceil(ev.currentTarget.mouseY / Game.cell_pixels);
						place();
					}
					else if (target_cell.x != point.x && target_cell.y != point.y)
					{
						trace("=point")						
						target_cell = point						
					}
				}
			}
			function deselect(ev:MouseEvent)
			{
				if (ev.ctrlKey == false && ev.target.constructor != Sprite)
				{
					graphics.clear();
					m.removeEventListener(MouseEvent.MOUSE_DOWN,map_down);
					target_cell = null;
					point = null
				}
			}
		}
	}
}