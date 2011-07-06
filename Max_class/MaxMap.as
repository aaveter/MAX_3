package Max_class
{
	import Main.Game;
	import flash.geom.Rectangle;
	import flash.display.Sprite;


	public class MaxMap extends Sprite
	{
		var map:Sprite=new Sprite();
		var map_units:Sprite=new Sprite();
		var setka:Sprite=new Sprite();
		var elements:Array=new Array();

		//map_size - размер карты
		//cell - массив всех клеток карты

		public function MaxMap(map_size:Number,cell:Array)
		{
			var map_place:Sprite;
			addChild(map_units);
			addChild(map);
			addChild(setka);
			//Функция оптимизирующая затраты на графическую визуализацию
			var gor_start:int = new int  ;
			var vert_start:int = new int  ;
			var gor_length:int = new int  ;
			var vert_length:int = new int  ;			

			
/*			var me:MapElement=new MapElement("water");
			elements[0]=me;
			me.addPoint(new MapPoint(20,20));
			me.addPoint(new MapPoint(220,40));
			me.addPoint(new MapPoint(220,320));
			me.addPoint(new MapPoint(20,220));

			map.graphics.beginFill(0x00FF00);
			map.graphics.drawRect(0,0,map_size*100,map_size*100);
			map.graphics.endFill();
			
			for (var i:int=0; i < elements.length; i++) {
				var ucol:int;
				
				if (elements[i].type=="water") {
					ucol = 0x0000FF;
				}
				else ucol = 0x00FF00;
				
				map.graphics.lineStyle(2,ucol);
				map.graphics.beginFill(ucol);
				
				var poLast:MapPoint = elements[i].points[elements[i].points.length-1];
				map.graphics.moveTo(poLast.x,poLast.y);
				for (var j:int=0; j < elements[i].points.length; j++) {
					var po:MapPoint = elements[i].points[j];
					var dx:int = poLast.x - po.x;
					var dy:int = poLast.y - po.y;
					map.graphics.curveTo( poLast.x-dx/2+10,poLast.y-dy/2+10,po.x,po.y);
					poLast=po;
				}
				
				map.graphics.endFill();
			}
			
			//setka.graphics.beginFill(0xFF0000);
			setka.graphics.lineStyle(2);
			for (var i:int = 0; i < map_size; i++) {
				setka.graphics.moveTo(i*100,0);
				setka.graphics.lineTo(i*100,map_size*100);
			}
			for (var i:int = 0; i < map_size; i++) {
				setka.graphics.moveTo(0,i*100);
				setka.graphics.lineTo(map_size*100,i*100);
			}*/

			//Подготовка к оптимизации
			for (var gor:int = 0; gor<map_size; gor++)
			{
				for (var vert:int = 0; vert<map_size; vert++)
				{
					cell[gor][vert]["optimize"] = 0;
				}
			}

			for (gor = 0; gor<map_size; gor++)
			{
				gor_start = gor;
				for (vert = 0; vert<map_size; vert++)
				{
					gor_length = 1;
					vert_start = vert;
					vert_length = 1;
					if (cell[gor][vert]["optimize"] != 1)
					{
						cell[gor][vert]["optimize"] = 1;
						while (vert<map_size-1&&cell[gor][vert]["type"]==cell[gor][vert+1]["type"]&&cell[gor][vert+1]["optimize"]!=1)
						{
							vert_length +=  1;
							vert +=  1;
							cell[gor][vert]["optimize"] = 1;
						}
						vert = vert_start;
						while (gor<map_size-1&&cell[gor][vert]["type"]==cell[gor+1][vert]["type"]&&vert_start+vert_length>vert)
						{
							vert +=  1;
							if (vert_start + vert_length == vert)
							{
								gor_length +=  1;
								gor +=  1;
								for (vert = vert_start; vert_start+vert_length>vert; vert++)
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
						else if (cell[gor_start][vert_start]["type"]=="water")
						{
							map.graphics.beginBitmapFill(Game.water_dark);
							map_units.graphics.beginBitmapFill(Game.water);
						}
						else if (cell[gor_start][vert_start]["type"]=="montain")
						{
							map.graphics.beginBitmapFill(Game.montain_dark);
							map_units.graphics.beginBitmapFill(Game.montain);
						}

						map.graphics.drawRect(gor_start*Game.cell_pixels, vert_start*Game.cell_pixels, Game.cell_pixels*gor_length, Game.cell_pixels*vert_length);
						map.graphics.endFill();
						map_units.graphics.drawRect(gor_start*Game.cell_pixels, vert_start*Game.cell_pixels, Game.cell_pixels*gor_length, Game.cell_pixels*vert_length);
						map_units.graphics.endFill();
						vert = vert_start + vert_length - 1;
						gor = gor_start;
					}
				}
			}
		}
	}
}