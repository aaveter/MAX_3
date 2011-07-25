package Units
{
	import flash.display.*;
	import Main.*
	
	public class construct extends unit_class
	{
		public function construct()
		{			
			addChild(new construct_bmp)
			unit_name = "Конструктор";//Наименование юнита
			hp = 18;//Кол-во жизней юнита
			armor = 4;//Броня юнита уменьшает наносимый урон
			speed = 6;//Скорость юнита						
			type_move = "13";//Вид передвижения юнита 1 - по земле, 2 - по воздуху, 3 - по воде, 
			//4 - под водой, 5 - по горам		
			cost = 18;//Стоимость постройки в ресурсах, отсюда же стоимость покупки береться и длительность строительства.			
			scan = 5;//Видимая зона вокруг юнита
			build = "true";//Параметр показывает строит ли юнит здания. (true or false)												
		}		
	}
}
