package Max_class
{	
	import flash.net.*
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import Main.*;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.net.FileReferenceList;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.geom.Point;

	public class kadr_2 extends Sprite
	{
		/*public function kadr_2()
		{
			var urlRequestMap:URLRequest = new URLRequest("map3.txt");
			var urlLoaderMap:URLLoader=new URLLoader();
			urlLoaderMap.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoaderMap.load(urlRequestMap);
			urlLoaderMap.addEventListener(Event.COMPLETE, maps_complete);
			function maps_complete(ev:Event)
			{
				var k3:kadr_3=new kadr_3(urlLoaderMap)
				//addChild(k3)
				Game.setKadr(k3);
			}
		}*/
		
		//var main:MaxMain;
		//Загружаю все созданные карты
		var mini_maps_place:Sprite;
		var mini_maps:Array;
		var map_size_text:Array;
		var mst_format:TextFormat;
		var maps_ref:FileReferenceList;
		var i:int;
		var qx:int;//Количество мини-карт которое помещается в строке
		var cmm:Sprite;//Показывает, что выбрана именно эта карта

		var urlRequest:URLRequest;
		var urlLoader:URLLoader;
		
		var mapsCount:int;
		
		var urlRequestMap:URLRequest;
		var urlLoaderMap:Array;

		public function kadr_2() {
			// constructor code
			//main = main_;
			
			//Загружаю все созданные карты
			mini_maps_place =new Sprite  ;
			mini_maps =new Array  ;
			map_size_text =new Array  ;
			mst_format = new TextFormat();
			maps_ref =new FileReferenceList();
			i = -1;
			qx = Math.floor((Game.doc_x-20)/(Game.map_x+Game.mmd));//Количество мини-карт которое помещается в строке
			cmm =new Sprite  ;//Показывает, что выбрана именно эта карта
			
			cmm.graphics.lineStyle(2, 0x000099);
			cmm.graphics.drawRect(0, 0, 250, 250);
			
			addChild(mini_maps_place);
			
			urlLoaderMap=new Array;
			mapsCount=0;
			
			urlRequest = new URLRequest("maps_list.txt");
			urlLoader = new URLLoader();
			urlLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
			urlLoader.load(urlRequest);
			
		}		
		
		function urlLoader_complete(evt:Event):void {
			mapsCount=urlLoader.data.maps_count;
			//trace("mapsCount = " + mapsCount.toString());
			cmm.x=(Game.map_x+Game.mmd)*((i+1)-qx*Math.floor((i+1)/qx))+20;
			cmm.y=(Game.map_x+Game.mmd+20)*Math.floor((i+1)/qx)+20;
			
			load_next_map();
		}
		
		function maps_complete(evt:Event) {
			trace("loadStandartMap() = " + i.toString());
			loadStandartMap();
		}
		
		function maps_completeGraphics(evt:Event) {
			trace("loadGraphicsMap() = " + i.toString());
			loadGraphicsMap();
		}
		
		function loadGraphicsMap() {
			trace(i);
			//var cell:Array=new Array  ;
			var map_size:int = urlLoaderMap[i].data.readInt(); trace("map_size=" +String(map_size));
			var objects_count:int = urlLoaderMap[i].data.readInt(); trace("obj_count=" +String(objects_count));
			
			mini_maps[i] = new Sprite  ;
			map_size_text[i]=new TextField  ;	
			//var gor_start:int=new int  ;
			//var vert_start:int=new int  ;
			//var gor_length:int=new int  ;
			//var vert_length:int=new int  ;
			
			var mnoz:int = Game.mini_cs;
			var delit:int = 100;
			
			mini_maps[i].graphics.beginFill(0x00FF00);
			mini_maps[i].graphics.drawRect(0,0,map_size*mnoz,map_size*mnoz);
			mini_maps[i].graphics.endFill();
			
			var elements:Array = new Array();
			
			for (var k:int = 0; k < objects_count; ++k) {
				var me:MapElement = null;
				var obj_type:int = urlLoaderMap[i].data.readInt();
				if (obj_type == 1) {
					trace("obj[" + k.toString() +"] = water");
					me = new MapElement("water");
				} else {
					trace("obj[" + k.toString() +"] = green");
					me = new MapElement("green");
				}
				elements[k] = me;
				var obj_points:int = urlLoaderMap[i].data.readInt();
				trace("obj[" + k.toString() +"] points = " + obj_points.toString());
				for (var g:int = 0; g < obj_points; ++g) {
					var obj_x:int = urlLoaderMap[i].data.readInt();
					var obj_y:int = urlLoaderMap[i].data.readInt();
					trace("obj[" + k.toString() +"].point["+g.toString()+"].x = " + obj_x.toString() + " y = " + obj_y.toString());
					me.addPoint(new MapPoint(obj_x,obj_y));
				}
			}
				
			for (var e:int=0; e < elements.length; e++) {
				var ucol:int;
				
				if (elements[e].type=="water") {
					ucol = 0x0000FF;
				} else {
					ucol = 0x00FF00;
				}
				
				mini_maps[i].graphics.lineStyle(2,ucol);
				mini_maps[i].graphics.beginFill(ucol);
				
				var poLength:int = elements[e].points.length;
				
				var poLast:MapPoint = elements[e].points[poLength-1];
				var preLast:MapPoint = elements[e].points[poLength-2];
				
				mini_maps[i].graphics.moveTo(poLast.x*mnoz/delit,poLast.y*mnoz/delit);
				
				for (var j:int=0; j < poLength; j++) {
					var po:MapPoint = elements[e].points[j];
					var poNext:MapPoint = null;
					if (j+1 < poLength) {
						poNext = elements[e].points[j+1];
					} else {
						poNext = elements[e].points[0];
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
					//map.graphics.drawCircle(poMid.x,poMid.y,4);
					
					var mdx:int = poMezdu.x - poMid.x;
					var mdy:int = poMezdu.y - poMid.y;
					
					var mdist:int = Point.distance(c,poMid);
					
					var sca:Number = rSr/mdist;
					
					var rezPo:Point = new Point(poMezdu.x - mdx*sca, poMezdu.y - mdy*sca);
					
					//map.graphics.moveTo(poMid.x,poMid.y);
					//map.graphics.lineTo(poMezdu.x,poMezdu.y);
					//map.graphics.lineTo(rezPo.x,rezPo.y);
					
					mini_maps[i].graphics.curveTo(rezPo.x*mnoz/delit,rezPo.y*mnoz/delit, po.x*mnoz/delit,po.y*mnoz/delit);
					
					preLast = poLast;
					poLast = po;
				}
				
				mini_maps[i].graphics.endFill();
				
			}
			mst_format=Formats.Static;
			mst_format.size=12;
			map_size_text[i].text="Карта размером "+map_size+" на "+map_size;
			map_size_text[i].setTextFormat(mst_format);
			map_size_text[i].x=(Game.map_x+Game.mmd)*(i-qx*Math.floor(i/qx))+20;
			map_size_text[i].y=(Game.map_x+Game.mmd+20)*Math.floor(i/qx);
			map_size_text[i].width=Game.map_x;
			map_size_text[i].height=20;
			mini_maps[i].width=Game.map_x;
			mini_maps[i].height=Game.map_x;
			mini_maps[i].x=(Game.map_x+Game.mmd)*(i-qx*Math.floor(i/qx))+20;
			mini_maps[i].y=(Game.map_x+Game.mmd+20)*Math.floor(i/qx)+20;	
		
			load_next_map();
		}
		
		function loadStandartMap() {
			var cell:Array=new Array  ;
			var map_size:int=urlLoaderMap[i].data.readInt();
			mini_maps[i]=new Sprite  ;
			map_size_text[i]=new TextField  ;	
			var gor_start:int=new int  ;
			var vert_start:int=new int  ;
			var gor_length:int=new int  ;
			var vert_length:int=new int  ;
			for (var gor:int = 0; gor<map_size; gor++) {
				cell[gor]=new Array  ;
				for (var vert:int = 0; vert<map_size; vert++) {
					cell[gor][vert] = new Array(
					"type",
					"optimize"
					);
					cell[gor][vert]["type"]=urlLoaderMap[i].data.readUTF();
					cell[gor][vert]["optimize"]=0;
				}
			}
			for (gor = 0; gor<map_size; gor++) {
				gor_start=gor;
				for (vert = 0; vert<map_size; vert++) {
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
							mini_maps[i].graphics.beginFill(0x00FF00);
						} else if (cell[gor_start][vert_start]["type"]=="water") {
							mini_maps[i].graphics.beginFill(0x9999FF);
						} else if (cell[gor_start][vert_start]["type"]=="montain") {
							mini_maps[i].graphics.beginFill(0x999999);
						}
						mini_maps[i].graphics.drawRect(gor_start*Game.mini_cs,vert_start*Game.mini_cs,Game.mini_cs*gor_length,Game.mini_cs*vert_length);
						mini_maps[i].graphics.endFill();
						vert=vert_start+vert_length-1;
						gor=gor_start;
					}
				}
			}
			mst_format=Formats.Static;
			mst_format.size=12;
			map_size_text[i].text="Карта размером "+map_size+" на "+map_size;
			map_size_text[i].setTextFormat(mst_format);
			map_size_text[i].x=(Game.map_x+Game.mmd)*(i-qx*Math.floor(i/qx))+20;
			map_size_text[i].y=(Game.map_x+Game.mmd+20)*Math.floor(i/qx);
			map_size_text[i].width=Game.map_x;
			map_size_text[i].height=20;
			mini_maps[i].width=Game.map_x;
			mini_maps[i].height=Game.map_x;
			mini_maps[i].x=(Game.map_x+Game.mmd)*(i-qx*Math.floor(i/qx))+20;
			mini_maps[i].y=(Game.map_x+Game.mmd+20)*Math.floor(i/qx)+20;	
		
			load_next_map();
		}
		
		function load_next_map() {
			if (i<mapsCount-1) {
				i+=1;
				
				trace(i.toString() + ":" +urlLoader.data["map" + (i+1).toString()]);
				
				urlRequestMap = new URLRequest(urlLoader.data["map" + (i+1).toString()]);
				urlLoaderMap[i] = new URLLoader();
				urlLoaderMap[i].dataFormat = URLLoaderDataFormat.BINARY;
				
				trace("type = " + urlLoader.data["map" + (i+1).toString() + "_type"]);
				if ( urlLoader.data["map" + (i+1).toString() + "_type"] == "graphics") {
					Game.mapType = "graphics";
					urlLoaderMap[i].addEventListener(Event.COMPLETE, maps_completeGraphics);
				} else {
					Game.mapType = "standart";
					urlLoaderMap[i].addEventListener(Event.COMPLETE, maps_complete);
				}
				
				urlLoaderMap[i].load(urlRequestMap);
		
			} else {
				finalize();
			}
		}
		
		function mm_click(event:MouseEvent) {	
			i=Math.floor((mouseX-mini_maps_place.x)/(Game.map_x+Game.mmd))
				+qx*Math.floor((mouseY-mini_maps_place.y)/(Game.map_x+Game.mmd));
			cmm.x=(Game.map_x+Game.mmd)*(i-qx*Math.floor(i/qx))+20;
			cmm.y=(Game.map_x+Game.mmd+20)*Math.floor(i/qx)+20;
		}
		
		function finalize() {
			for (i=0; i<mini_maps.length; i++) {
				mini_maps[i].addEventListener(MouseEvent.CLICK,mm_click);
				mini_maps_place.addChild(mini_maps[i]);
				mini_maps_place.addChild(map_size_text[i]);
			}
			mini_maps_place.addChild(cmm);
			i=0;
			var Ok_2=new Button_press(Formats.Static);
			addChild(Ok_2);
			Ok_2.x=(Game.doc_x-Ok_2.width)/2;
			Ok_2.y=Game.doc_y-Ok_2.height-100;
			Ok_2.addEventListener(MouseEvent.CLICK, press_Ok_2);
		}
		
		function press_Ok_2(event:MouseEvent) {
			trace("press_Ok_2 = " + i.toString());
			var k3:kadr_3=new kadr_3(urlLoaderMap[i]);
			Game.setKadr(k3);
		}
		
	}
}