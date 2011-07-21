package Max_class
{
	import Main.Game;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class MaxMap extends Sprite
	{
		var map:Sprite=new Sprite();
		var map_units:Sprite=new Sprite();
		var setka:Sprite=new Sprite();
		//var elements:Array=new Array();

		//map_size - размер карты
		//cell - массив всех клеток карты
		
		

		public function MaxMap(mapObject:MapClass)
		{
			var map_place:Sprite;
			addChild(map_units);
			addChild(map);
			addChild(setka);
			//Функция оптимизирующая затраты на графическую визуализацию
						
			mapObject.draw(map, 100, map_units);
						
			initSetka(mapObject.width);
		}
		
		public function initSetka(map_size:int) {
			setka.graphics.lineStyle(2);
			for (var i:int = 0; i < map_size; i++) {
				setka.graphics.moveTo(i*100,0);
				setka.graphics.lineTo(i*100,map_size*100);
			}
			for (i = 0; i < map_size; i++) {
				setka.graphics.moveTo(0,i*100);
				setka.graphics.lineTo(map_size*100,i*100);
			}
		}	
	}
}