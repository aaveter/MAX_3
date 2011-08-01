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
	import flash.text.TextField;

	public class unit_class extends Sprite
	{
		public var unit_name:String;//Наименование юнита
		public var hp:Number,cur_hp:Number;//Кол-во жизней юнита
		public var armor:Number;//Броня юнита уменьшает наносимый урон
		public var speed:Number = 0,cur_speed:Number = 0;//Скорость юнита
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
		public var gor:Number = 0,vert:Number = 0;//Горизонтальное и вертикальное положение юнита на карте
		public var scan_area:Sprite = new Sprite  ;
		public var mini_scan_area:Sprite = new Sprite  ;
		public var mini_bmp:Sprite = new Sprite  ;
		var target_x:Number=new Number();//Точка, в которую должен переместиться юнит
		var target_y:Number=new Number();//Точка, в которую должен переместиться юнит
		var point_x:Number=new Number();//Временная точка, используется для проверки что мы второй раз ткунли туда же.
		var point_y:Number=new Number();//Временная точка, используется для проверки что мы второй раз ткунли туда же.
		var path:Sprite =new Sprite();//Здесь рисуем маршрут по которому пойдет юнит
		var circle:Sprite =new Sprite();//Здесь рисуем окружность, обозначающую, что юнит выбран
		var player:int = new int();//Номер игрока которому принадлежит данный юнит
		var m:MaxMap;
		var mini_cs:int;
		var color:uint;
		var this_ = this;

		public function unit_class()
		{
		}

		public function create_unit(map:MaxMap,mm:MaxMiniMap,g,v,c,mcs=4)
		{
			m = map;
			mini_cs = mcs;
			color = c
			;
			m.addChild(path);
			addChild(circle);
			player = Game.player;
			mini_bmp.graphics.beginFill(color);
			mini_bmp.graphics.drawRect(0,0,mini_cs,mini_cs);
			scan_area.graphics.beginFill(0x000099);
			mini_scan_area.graphics.beginFill(0x000099);
			scan_area.graphics.drawCircle(0,0,scan*Game.cell_pixels);
			mini_scan_area.graphics.drawCircle(0,0,scan*mini_cs);
			gor = g;
			vert = v;
			cur_hp = hp;
			m.map_units.addChild(this);
			mm.mini_map_units.addChild(mini_bmp);
			Game.scan_zone.addChild(scan_area);
			Game.mini_scan_zone.addChild(mini_scan_area);
			place();
			addEventListener(MouseEvent.MOUSE_DOWN,select_down);

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
				if (ev.ctrlKey == false && ev.target.constructor != Sprite)
				{
					if (Game.player == player)
					{
						for (var i = 0; i<Game.Players[Game.player].units.length; i++)
						{
							Game.Players[Game.player].units[i].deselect();
						}
						output_inf();
						circle.graphics.lineStyle(2,0x000000);
						circle.graphics.drawCircle(0,0,50);
						m.addEventListener(MouseEvent.MOUSE_DOWN,map_down);
						Game.selected_unit = this_;
					}
					else if (Game.player != player)
					{
						if (Game.selected_unit.power - armor > 0)
						{
							cur_hp -=  Game.selected_unit.power - armor;
						}
						else
						{
							cur_hp -=  1;
						}
						if (cur_hp < 0)
						{
							m.map_units.removeChild(this_);
							for (i = 0; i<Game.Players[player].units.length; i++)
							{
								if (Game.Players[player].units[i] == this_)
								{
									Game.Players[player].units.splice(i,1);
									break;
								}
							}
						}
					}
				}
			}
		}
		public function place()
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
		public function map_down(ev:MouseEvent)
		{
			var time:Timer = new Timer(200,1);
			time.start();
			time.addEventListener(TimerEvent.TIMER_COMPLETE,compl);
			m.addEventListener(MouseEvent.MOUSE_UP,moving);
			function compl(ev:TimerEvent)
			{
				m.removeEventListener(MouseEvent.MOUSE_UP,moving);
			}
		}
		public function moving(ev:MouseEvent)
		{
			if (target_x == 0 && ev.target.constructor == Sprite)
			{
				target_x = Math.ceil(ev.currentTarget.mouseX / Game.cell_pixels);
				target_y = Math.ceil(ev.currentTarget.mouseY / Game.cell_pixels);
				create_path();
			}
			else if (target_x != 0 && ev.target.constructor == Sprite)
			{
				path.graphics.clear();
				point_x = Math.ceil(ev.currentTarget.mouseX / Game.cell_pixels);
				point_y = Math.ceil(ev.currentTarget.mouseY / Game.cell_pixels);
				if (target_x == point_x && target_y == point_y)
				{
					create_move();
				}
				else if (target_x != point_x || target_y != point_y)
				{
					target_x = point_x;
					target_y = point_y;
					create_path();
				}
			}
		}
		public function create_move()
		{
			var xx:int = Math.abs(target_x - gor);
			var yy:int = Math.abs(target_y - vert);
			if (cur_speed > 0.5)
			{
				for_place(xx,yy);
			}
		}
		public function for_place(xx,yy)
		{
			var rot_st:Number = rotation;//Состояние повернутости на начала поворота
			var rot_fin:Number;//Состояние повернутости на конец поворота
			var side:int = 1;//В какую сторону поворачиваться 1 - по часовой; -1 - против часовой
			var i_x:Number = 0;//Определяет нужно ли перемещаться по X
			var i_y:Number = 0;//Определяет нужно ли перемещаться по Y
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
			if (xx >= yy * 2)
			{
				xx -=  1;
				i_x = side_x;
				point_x = gor + 1 * side_x;
				point_y = vert;
				rot_fin = 90 * side_x;
			}
			else if (xx*2 <= yy)
			{
				yy -=  1;
				i_y = side_y;
				point_y = vert + 1 * side_y;
				point_x = gor;
				rot_fin = 90 + 90 * side_y;
			}
			else
			{
				xx -=  1;
				yy -=  1;
				i_x = side_x;
				i_y = side_y;
				point_x = gor + 1 * side_x;
				point_y = vert + 1 * side_y;
				rot_fin = 45 + 45 * side_x + 45 * side_y;
				if (side_x == -1 && side_y == 1)
				{
					rot_fin -=  180;
				}
			}
			var times:int = Math.abs(rot_fin - rot_st) / 5;
			if (Math.abs(rot_fin - rot_st) <= 180)
			{
				if (rot_st > rot_fin)
				{
					side = -1;
				}
			}
			else if (Math.abs(rot_fin - rot_st) > 180)
			{
				if (rot_fin > rot_st)
				{
					side = -1;
				}
				times = (360 - Math.abs(rot_fin - rot_st))/5;
			}
			if (times != 0)
			{
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
						move_part();
					}
				}
			}
			else
			{
				move_part();
			}
			function move_part()
			{
				var time:Timer = new Timer(10,10);
				var timer:int = 0;
				time.start();
				time.addEventListener(TimerEvent.TIMER,timing);
				function timing(ev:TimerEvent)
				{
					gor +=  i_x / 10;
					vert +=  i_y / 10;
					timer +=  1;
					place();
					if (timer == 10)
					{
						gor = point_x;
						vert = point_y;
						place();
						if (rotation / 90 == Math.round(rotation / 90))
						{
							cur_speed -=  1;
						}
						else if (rotation / 45 == Math.round(rotation / 45))
						{
							cur_speed -=  1.5;
						}
						output_inf();
						if (gor != target_x || vert != target_y)
						{
							if (cur_speed > 0.5)
							{
								for_place(xx,yy);
							}
						}
					}
				}
			}
		}
		public function output_inf()
		{
			Game.unit_TF.text = "";
			Game.unit_TF.appendText("Скорость: "+cur_speed.toString()+"/"+speed.toString()+ "\n");
			Game.unit_TF.appendText("Прочность: "+cur_hp.toString()+"/"+hp.toString()+ "\n");
			Game.unit_TF.appendText("Радар: "+scan.toString());
		}
		public function deselect()
		{
			m.removeEventListener(MouseEvent.MOUSE_DOWN,map_down);
			circle.graphics.clear();
			path.graphics.clear();
			target_x = 0;
			target_y = 0;
			point_x = 0;
			point_y = 0;
		}
		public function create_path()
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