package Max_class {
	
	import Main.*;
	import flash.net.URLLoader;
	import flash.display.Sprite;
	
	public class StandartMap extends MapClass {

		var cell:Array = new Array;
		var gor_start:int = new int;
		var vert_start:int = new int;
		var gor_length:int = new int;
		var vert_length:int = new int;

		public function StandartMap() {
			// constructor code
		}
		
		override public function load(loader:URLLoader) {
			loader.data.position = 0;
			var map_size:int = loader.data.readInt();
			width = map_size;
			height = map_size;
			
			//Считываем всю информацию по клеткам
			for (var gor = 0; gor<map_size; gor++)
			{
				cell[gor] = new Array  ;
				for (var vert = 0; vert<map_size; vert++)
				{
					cell[gor][vert] = new Array(
					"type",
					"optimize",
					"source_t",
					"source_n"
					);
					cell[gor][vert]["type"] = loader.data.readUTF();
					cell[gor][vert]["optimize"] = 0;
				}
			}
		}
		
		override public function draw( map:Sprite, cell_size:Number = 100, map_units:Sprite = null ) {
			var map_size:int = width;
			
			for (var gor:int = 0; gor<map_size; gor++) {
				gor_start=gor;
				for (var vert:int = 0; vert<map_size; vert++) {
					gor_length=1;
					vert_start=vert;
					vert_length=1;
					if (cell[gor][vert]["optimize"]!=1) {
						cell[gor][vert]["optimize"]=1;
						while (vert<map_size-1&&cell[gor][vert]["type"]==cell[gor][vert+1]["type"]&&cell[gor][vert+1]["optimize"]!=1) {
							vert_length+=1;
							vert+=1;
							cell[gor][vert]["optimize"]=1;
						}
						vert=vert_start;
						while (gor<map_size-1&&cell[gor][vert]["type"]==cell[gor+1][vert]["type"]&&vert_start+vert_length>vert) {
							vert+=1;
							if (vert_start+vert_length==vert) {
								gor_length+=1;
								gor+=1;
								for (vert = vert_start; vert_start+vert_length>vert; vert++) {
									cell[gor][vert]["optimize"]=1;
								}
								vert=vert_start;
							}
						}
						if (cell[gor_start][vert_start]["type"]=="green") {
							map.graphics.beginFill(0x00FF00);
							if (map_units!=null) {
								map_units.graphics.beginFill(0x33FF33);
							}
						} else if (cell[gor_start][vert_start]["type"]=="water") {
							map.graphics.beginFill(0x9999FF);
							if (map_units!=null) {
								map_units.graphics.beginFill(0xCCCCFF);
							}
						} else if (cell[gor_start][vert_start]["type"]=="montain") {
							map.graphics.beginFill(0x999999);
							if (map_units!=null) {
								map_units.graphics.beginFill(0xCCCCCC);
							}
						}
						map.graphics.drawRect(gor_start*cell_size, vert_start*cell_size, 
													   cell_size*gor_length, cell_size*vert_length);
						map.graphics.endFill();
						if (map_units!=null) {
							map_units.graphics.drawRect(gor_start*cell_size, vert_start*cell_size, 
													   cell_size*gor_length, cell_size*vert_length);
							map_units.graphics.endFill();
						}
						vert=vert_start+vert_length-1;
						gor=gor_start;
					}
				}
			}
		}

	}
	
}
