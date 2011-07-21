package Max_class {
	
	import flash.net.URLLoader;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class GraphicsMap extends MapClass {
		
		var elements:Array = null;
		var ground:String;

		public function GraphicsMap() {
			// constructor code
		}
		
		override public function load(loader:URLLoader) {
			
			if (elements != null) return;
			
			// + map_type
			// + version
			// + ground
			ground = "green";
			
			var map_size:int = loader.data.readInt();
			width = map_size;
			height = map_size;
			var objects_count:int = loader.data.readInt();
			
			elements = new Array();
			
			for (var k:int = 0; k < objects_count; ++k) {
				var me:MapElement = null;
				var obj_type:int = loader.data.readInt();
				if (obj_type == 1) {
					me = new MapElement("water");
				} else {
					me = new MapElement("green");
				}
				elements[k] = me;
				var obj_points:int = loader.data.readInt();
				for (var g:int = 0; g < obj_points; ++g) {
					var obj_x:int = loader.data.readInt();
					var obj_y:int = loader.data.readInt();
					me.addPoint(new MapPoint(obj_x,obj_y));
				}
			}
			
		}
		
		override public function draw( map:Sprite, cell_size:Number = 100, map_units:Sprite = null ) {
			var col:int = 0;
			if (ground == "green") col = 0x00FF00;
			else if (ground == "water") col = 0x0000FF;
			
			map.graphics.beginFill(col);
			map.graphics.drawRect(0,0,width*cell_size,height*cell_size);
			map.graphics.endFill();
			
			if (map_units!=null) {
				map_units.graphics.beginFill(col-30);
				map_units.graphics.drawRect(0,0,width*cell_size,height*cell_size);
				map_units.graphics.endFill();
			}
			
			for (var i:int=0; i < elements.length; i++) {
				var ucol:int;
				
				if (elements[i].type=="water") {
					ucol = 0x0000FF;
				} else {
					ucol = 0x00FF00;
				}
				
				map.graphics.lineStyle(2,ucol);
				map.graphics.beginFill(ucol);
				
				var poLength:int = elements[i].points.length;
				
				var poLast:MapPoint = elements[i].points[poLength-1];
				var preLast:MapPoint = elements[i].points[poLength-2];
				
				map.graphics.moveTo(poLast.x*cell_size/standart_cell_size, poLast.y*cell_size/standart_cell_size);
				if (map_units!=null) {
					map_units.graphics.lineStyle(2,ucol-30);
					map_units.graphics.beginFill(ucol-30);
					map_units.graphics.moveTo(poLast.x*cell_size/standart_cell_size, poLast.y*cell_size/standart_cell_size);
				}
				
				for (var j:int=0; j < poLength; j++) {
					var po:MapPoint = elements[i].points[j];
					var poNext:MapPoint = null;
					if (j+1 < poLength) {
						poNext = elements[i].points[j+1];
					} else {
						poNext = elements[i].points[0];
					}
					
					var dx:int = 0;
					var dy:int = 0;
					
					dx = preLast.x - poNext.x;
					dy = preLast.y - poNext.y;
					
					var poMezdu:MapPoint = new MapPoint(preLast.x - dx/2, preLast.y - dy/2); 
					
					var a:Point = new Point(poLast.x,poLast.y);
					var b:Point = new Point(po.x,po.y);
					var c:Point = new Point(poMezdu.x,poMezdu.y);
					
					var r1:int = Point.distance(a,c);
					var r2:int = Point.distance(b,c);
					var rSr:int = (r1 + r2)/2;
					
					var poMid:Point = new Point(poLast.x - (poLast.x-po.x)/2, poLast.y - (poLast.y-po.y)/2);
					
					var mdx:int = poMezdu.x - poMid.x;
					var mdy:int = poMezdu.y - poMid.y;
					
					var mdist:int = Point.distance(c,poMid);
					
					var sca:Number = rSr/mdist;
					
					var rezPo:Point = new Point(poMezdu.x - mdx*sca, poMezdu.y - mdy*sca);
					
					map.graphics.curveTo(rezPo.x*cell_size/standart_cell_size, rezPo.y*cell_size/standart_cell_size, 
										 po.x*cell_size/standart_cell_size, po.y*cell_size/standart_cell_size);
					if (map_units!=null) {
						map_units.graphics.curveTo(rezPo.x*cell_size/standart_cell_size, rezPo.y*cell_size/standart_cell_size, 
										 po.x*cell_size/standart_cell_size, po.y*cell_size/standart_cell_size);
					}
					
					preLast = poLast;
					poLast = po;
				}
				
				map.graphics.endFill();
				
				
				/*map.graphics.lineStyle(2,0xFF0000);
				map.graphics.beginFill(0xFF0000);
				
				poLast = elements[i].points[poLength-1];
				preLast = elements[i].points[poLength-2];
				
				for (var j:int=0; j < poLength; j++) {
					var po:MapPoint = elements[i].points[j];
					var poNext:MapPoint = null;
					if (j+1 < poLength) {
						poNext = elements[i].points[j+1];
					} else {
						poNext = elements[i].points[0];
					}
					
					var dx:int = preLast.x - poNext.x;//poLast.x - po.x;
					var dy:int = preLast.y - poNext.y;//poLast.y - po.y;
					
					var xPlus:int = 0;//10;
					var yPlus:int = 0;//10;
					
					var poMezdu:MapPoint = new MapPoint(poLast.x-dx/2 + xPlus, poLast.y-dy/2 + yPlus);
					
					map.graphics.drawCircle(po.x,po.y, 2);
					
					//map.graphics.lineStyle(2,0xFF0000);
					//map.graphics.drawCircle(poMezdu.x,poMezdu.y, 2);
					
					preLast = poLast;
					poLast = po;
				}
				map.graphics.endFill();
				
				
				map.graphics.lineStyle(2,0x000000);
				map.graphics.beginFill(0x000000);
				
				poLast = elements[i].points[poLength-1];
				preLast = elements[i].points[poLength-2];
				
				for (var j:int=0; j < poLength; j++) {
					var po:MapPoint = elements[i].points[j];
					var poNext:MapPoint = null;
					if (j+1 < poLength) {
						poNext = elements[i].points[j+1];
					} else {
						poNext = elements[i].points[0];
					}
					
					var dx:int = 0;
					var dy:int = 0;
					
					//if (preLast.x > poNext.x) 
					dx = preLast.x - poNext.x;//poLast.x - po.x;
					//else dx = poNext.x - preLast.x;
					
					//if (preLast.y > poNext.y) 
					dy = preLast.y - poNext.y;//poLast.y - po.y;
					//else dy = poNext.y - preLast.y;
					
					var xPlus:int = 0;//10;
					var yPlus:int = 0;//10;
					
					//if (poLast.x )
					
					var poMezdu:MapPoint = new MapPoint(preLast.x - dx/2 + xPlus, preLast.y - dy/2 + yPlus); 
					
					var a:Point = new Point(poLast.x,poLast.y);
					var b:Point = new Point(po.x,po.y);
					var c:Point = new Point(poMezdu.x,poMezdu.y);
					
					var r1:int = Point.distance(a,c);
					var r2:int = Point.distance(b,c);
					var rSr:int = (r1 + r2)/2;
					
					var poMid:Point = new Point(poLast.x - (poLast.x-po.x)/2, poLast.y - (poLast.y-po.y)/2);
					map.graphics.drawCircle(poMid.x,poMid.y,4);
					
					var mdx:int = poMezdu.x - poMid.x;
					var mdy:int = poMezdu.y - poMid.y;
					
					var mdist:int = Point.distance(c,poMid);
					
					var sca:Number = rSr/mdist;
					
					var rezPo:Point = new Point(poMezdu.x - mdx*sca, poMezdu.y - mdy*sca);
					
					map.graphics.moveTo(poMid.x,poMid.y);
					map.graphics.lineTo(poMezdu.x,poMezdu.y);
					map.graphics.lineTo(rezPo.x,rezPo.y);
					
					//map.graphics.drawCircle(po.x,po.y, 2);
					
					//map.graphics.lineStyle(2,0xFF0000);
					map.graphics.drawCircle(poMezdu.x,poMezdu.y, 2);
					
					preLast = poLast;
					poLast = po;
				}
				map.graphics.endFill();*/
				
			}
			
			//setka.graphics.beginFill(0xFF0000);
			/*setka.graphics.lineStyle(2);
			for (var i:int = 0; i < map_size; i++) {
				setka.graphics.moveTo(i*100,0);
				setka.graphics.lineTo(i*100,map_size*100);
			}
			for (var i:int = 0; i < map_size; i++) {
				setka.graphics.moveTo(0,i*100);
				setka.graphics.lineTo(map_size*100,i*100);
			}*/
			
		}

	}
	
}
