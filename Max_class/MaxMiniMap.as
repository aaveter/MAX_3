package Max_class
{
	import Main.Game;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.events.*;

	public class MaxMiniMap extends Sprite
	{
		var mini_map:Sprite=new Sprite();
		var mini_map_units:Sprite=new Sprite();
		public var border_mm:Sprite = new border_class  ;
		var rect:Rectangle

		//map_size - размер карты
		//cell - массив всех клеток карты
		//w - размер мини карты по X
		//h - размер мини карты по Y
		//r - видимая часть карты (используется для прокрутки карты через мини)
		public function MaxMiniMap(map_size:Number,cell:Array,w:Number=200,h:Number=200,r:Rectangle=null)
		{
			addChild(mini_map_units);
			addChild(mini_map);
			addChild(border_mm);
			var gor_start:int = new int  ;
			var vert_start:int = new int  ;
			var gor_length:int = new int  ;
			var vert_length:int = new int  ;
			rect=r

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
						while (vert<map_size-1 && 
						   cell[gor][vert]["type"]==cell[gor][vert+1]["type"] && 
						   cell[gor][vert+1]["optimize"]!=1)
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
							mini_map.graphics.beginFill(0x009932);
							mini_map_units.graphics.beginFill(0x00CC33);
						}
						else if (cell[gor_start][vert_start]["type"]=="water")
						{
							mini_map.graphics.beginFill(0x0066FF);
							mini_map_units.graphics.beginFill(0x00CBFF);
						}
						else if (cell[gor_start][vert_start]["type"]=="montain")
						{
							mini_map.graphics.beginFill(0x333333);
							mini_map_units.graphics.beginFill(0x999999);
						}
						mini_map.graphics.drawRect(gor_start*Game.mini_cs,
						vert_start*Game.mini_cs,
						Game.mini_cs*gor_length,
						Game.mini_cs*vert_length
						);
						mini_map.graphics.endFill();
						mini_map_units.graphics.drawRect(gor_start*Game.mini_cs,
						vert_start*Game.mini_cs,
						Game.mini_cs*gor_length,
						Game.mini_cs*vert_length
						);
						mini_map_units.graphics.endFill();
						vert = vert_start + vert_length - 1;
						gor = gor_start;
					}
				}
			}
			border_mm.width = Game.visible_map_x / Game.cell_size * Game.mini_cs;
			border_mm.height = Game.visible_map_y / Game.cell_size * Game.mini_cs;
			width = w;
			height = h;

			//Передвижение по мини-карте
			this.addEventListener(MouseEvent.CLICK,replace);
			this.addEventListener(MouseEvent.MOUSE_MOVE,moving);
			function replace(ev:MouseEvent)
			{
				border_mm.x = ev.target.mouseX - border_mm.width / 2;
				border_mm.y = ev.target.mouseY - border_mm.height / 2;
				if (border_mm.x < 0)
				{
					border_mm.x = 0;
				}
				if (border_mm.x > mini_map.width - border_mm.width)
				{
					border_mm.x = mini_map.width - border_mm.width;
				}
				if (border_mm.y < 0)
				{
					border_mm.y = 0;
				}
				if (border_mm.y > mini_map.height - border_mm.height)
				{
					border_mm.y = mini_map.height - border_mm.height;
				}
				if (rect != null)
				{
					rect.x = border_mm.x / Game.mini_cs * Game.cell_size;
					rect.y = border_mm.y/Game.mini_cs*Game.cell_size;
				}
			}
			function moving(ev:MouseEvent)
			{
				if (ev.buttonDown == true)
				{
					replace(ev);
				}
			}
		}
		public function replace()
		{
			border_mm.x = rect.x/Game.cell_size*Game.mini_cs
			border_mm.y = rect.y/Game.cell_size*Game.mini_cs
		}
	}
}