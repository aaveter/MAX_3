﻿package Max_class
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
						
			mapObject.draw(map);
						
			initSetka(mapObject.width);
			//initStandartMap(map_size,cell);
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
		
		public function initGraphicsMap(map_size:Number,cell:Array) {
			
			/*map.graphics.beginFill(0x00FF00);
			map.graphics.drawRect(0,0,map_size*100,map_size*100);
			map.graphics.endFill();			
			
			var me:MapElement = new MapElement("water");
			elements[0] = me;
			me.addPoint(new MapPoint(350,350));
			me.addPoint(new MapPoint(520,350));
			me.addPoint(new MapPoint(550,380));
			me.addPoint(new MapPoint(550,520));
			me.addPoint(new MapPoint(520,550));
			me.addPoint(new MapPoint(350,550));

			var me2:MapElement = new MapElement("water");
			elements[1] = me2;
			me2.addPoint(new MapPoint(700,430));
			me2.addPoint(new MapPoint(780,400));
			me2.addPoint(new MapPoint(850,460));
			me2.addPoint(new MapPoint(990,290));
			me2.addPoint(new MapPoint(1060,150));
			me2.addPoint(new MapPoint(1240,700));
			me2.addPoint(new MapPoint(1030,670));
			me2.addPoint(new MapPoint(820,590));
			me2.addPoint(new MapPoint(770,530));

			
			
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
				
				map.graphics.moveTo(poLast.x,poLast.y);
				
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
					//map.graphics.drawCircle(poMid.x,poMid.y,4);
					
					var mdx:int = poMezdu.x - poMid.x;
					var mdy:int = poMezdu.y - poMid.y;
					
					var mdist:int = Point.distance(c,poMid);
					
					var sca:Number = rSr/mdist;
					
					var rezPo:Point = new Point(poMezdu.x - mdx*sca, poMezdu.y - mdy*sca);
					
					//map.graphics.moveTo(poMid.x,poMid.y);
					//map.graphics.lineTo(poMezdu.x,poMezdu.y);
					//map.graphics.lineTo(rezPo.x,rezPo.y);
					
					map.graphics.curveTo(rezPo.x,rezPo.y, po.x,po.y);
					
					preLast = poLast;
					poLast = po;
				}
				
				map.graphics.endFill();
				
				
				map.graphics.lineStyle(2,0xFF0000);
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
				map.graphics.endFill();
				
			}*/
			
			//setka.graphics.beginFill(0xFF0000);
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
		
		public function initStandartMap(map_size:Number,cell:Array) {

			
		}
	}
}