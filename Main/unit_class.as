package Main
{
	import flash.display.*;
	import Main.Game
	import flash.events.*;
	import flash.utils.*;

	public class unit_class extends Sprite
	{		
		public var bmp:Sprite;//Картинка как выглядит юнит
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
		var sel:Number = 0;// Показывает выбран юнит или нет
		public var gor:Number = 0,vert:Number = 0;//Горизонтальное и вертикальное положение юнита на карте

		public function unit_class()
		{					
		}
		public function create_unit(map_units,mini_map_units,g,v,color,cell_pixels=100,mini_cs=4)
		{
			mini_map_units.graphics.beginFill(color);
			mini_map_units.graphics.drawRect(g*mini_cs,v*mini_cs,mini_cs,mini_cs);
			gor = g;
			vert = v;
			map_units.addChild(bmp);
			bmp.x=(gor-0.5)*cell_pixels;
			bmp.y=(vert-0.5)*cell_pixels;
			map_units.addEventListener(MouseEvent.CLICK,deselect);
			bmp.addEventListener(MouseEvent.CLICK,select);
		}
		public function deselect(ev:MouseEvent)
		{
			if (ev.target.constructor == Sprite)
			{
				if (sel == 1)
				{
					bmp.x = ev.target.mouseX;
					bmp.y = ev.target.mouseY;
				}
				//moving();
			}
			else
			{
				sel = 0;
				bmp.graphics.clear();
			}
		}
		public function select(ev:MouseEvent)
		{
			var time:Timer = new Timer(1,1);
			time.start();
			time.addEventListener(TimerEvent.TIMER_COMPLETE,compl);
			function compl(event:TimerEvent)
			{
				sel = 1;
				ev.target.graphics.lineStyle(2,0x000000);
				ev.target.graphics.drawCircle(0,0,50);
			}
		}
		//public function check_cell()
//		{
//			gor:int=Math.ceil((map_rect.x+mouseX-map_place.x)/cell_size);				
//			vert:int=Math.ceil((map_rect.y+mouseY-map_place.y)/cell_size);					
//		}
		//public function moving();
		//{;
		//bmp.x=mouseX
		//bmp.y=mouseY
		//}
	}
}