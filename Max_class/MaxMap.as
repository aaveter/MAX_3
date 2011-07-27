package Max_class
{
	import Main.Game;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MaxMap extends Sprite
	{
		public var map:Sprite = new Sprite  ;
		public var map_units:Sprite = new Sprite  ;
		var setka:Sprite = new Sprite  ;
		//map_size - размер карты
		//cell - массив всех клеток карты
		var mapDrawer:MapClass = null;
		

		public function MaxMap(mapObject:MapClass)
		{
			addChild(map);
			addChild(map_units);
			addChild(setka);
			//Функция оптимизирующая затраты на графическую визуализацию
			var gor_start:int = new int  ;
			var vert_start:int = new int  ;
			var gor_length:int = new int  ;
			var vert_length:int = new int  ;
						
			mapObject.draw(map, 100, map_units);
						
			mapDrawer = mapObject;
			
			initSetka(mapObject.width);
			
			addEventListener(MouseEvent.MOUSE_MOVE,mouse_move);
		}
		
		public function mouse_move(ev:MouseEvent) {
			if (map_units) {
				trace(mapDrawer.cell_type(ev.localX/100, ev.localY/100, map_units, 100));
			}
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