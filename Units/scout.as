package Units
{
	import flash.display.*;
	import Main.*;
	public class scout extends unit_class
	{
		public function scout()
		{
			var bmp:Bitmap=new Bitmap(new scout_bmd)			
			bmp.width = 60
			bmp.height = bmp.width
			bmp.x=-bmp.width/2
			bmp.y=-bmp.height/2			
			addChild(bmp)
			
			;
			unit_name = "Скаут";//Наименование юнита
			hp = 12;//Кол-во жизней юнита
			armor = 4;//Броня юнита уменьшает наносимый урон
			speed = 12;//Скорость юнита
			power = 8
			type_move = "13";//Вид передвижения юнита 1 - по земле, 2 - по воздуху, 3 - по воде, 
			//4 - под водой, 5 - по горам
			cost = 18;//Стоимость постройки в ресурсах, отсюда же стоимость покупки береться и длительность строительства.
			scan = 9;//Видимая зона вокруг юнита
			build = "true";//Параметр показывает строит ли юнит здания. (true or false)
		}
	}
}