package Max_class
{
	import Main.Game;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MaxMap extends Sprite
	{
		public var map:Sprite = new Sprite  ;
		public var map_units:Sprite = new Sprite  ;
		var setka:Sprite = new Sprite  ;
		var elements:Array = new Array  ;
		//map_size - размер карты
		//cell - массив всех клеток карты

		public function MaxMap(map_size:Number,cell:Array)
		{
			addChild(map);
			addChild(map_units);
			addChild(setka);
			//Функция оптимизирующая затраты на графическую визуализацию
			var gor_start:int = new int  ;
			var vert_start:int = new int  ;
			var gor_length:int = new int  ;
			var vert_length:int = new int  ;

			//Подготовка к оптимизации
			for (var gor:int = 0; gor < map_size; gor++)
			{
				for (var vert:int = 0; vert < map_size; vert++)
				{
					cell[gor][vert]["optimize"] = 0;
				}
			}

			for (gor = 0; gor < map_size; gor++)
			{
				gor_start = gor;
				for (vert = 0; vert < map_size; vert++)
				{
					gor_length = 1;
					vert_start = vert;
					vert_length = 1;
					if (cell[gor][vert]["optimize"] != 1)
					{
						cell[gor][vert]["optimize"] = 1;
						while (vert < map_size - 1 && cell[gor][vert]["type"] == cell[gor][vert + 1]["type"] && cell[gor][vert + 1]["optimize"] != 1)
						{
							vert_length +=  1;
							vert +=  1;
							cell[gor][vert]["optimize"] = 1;
						}
						vert = vert_start;
						while (gor < map_size - 1 && cell[gor][vert]["type"] == cell[gor + 1][vert]["type"] && vert_start + vert_length > vert)
						{
							vert +=  1;
							if (vert_start + vert_length == vert)
							{
								gor_length +=  1;
								gor +=  1;
								for (vert = vert_start; vert_start + vert_length > vert; vert++)
								{
									cell[gor][vert]["optimize"] = 1;
								}
								vert = vert_start;
							}
						}
						if (cell[gor_start][vert_start]["type"] == "green")
						{
							map.graphics.beginBitmapFill(Game.green_dark);
							map_units.graphics.beginBitmapFill(Game.green);
						}
						else if (cell[gor_start][vert_start]["type"] == "water")
						{
							map.graphics.beginBitmapFill(Game.water_dark);
							map_units.graphics.beginBitmapFill(Game.water);
						}
						else if (cell[gor_start][vert_start]["type"] == "montain")
						{
							map.graphics.beginBitmapFill(Game.montain_dark);
							map_units.graphics.beginBitmapFill(Game.montain);
						}

						map.graphics.drawRect(gor_start * Game.cell_pixels,vert_start * Game.cell_pixels,Game.cell_pixels * gor_length,Game.cell_pixels * vert_length);
						map.graphics.endFill();
						map_units.graphics.drawRect(gor_start * Game.cell_pixels,vert_start * Game.cell_pixels,Game.cell_pixels * gor_length,Game.cell_pixels * vert_length);
						map_units.graphics.endFill();
						vert = vert_start + vert_length - 1;
						gor = gor_start;
					}
				}
			}
		}
	}
}