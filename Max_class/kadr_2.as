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
		var maps:Array = new Array();
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
		var statuser:LoadStatuser = null;

		public function kadr_2() {
			//Загружаю все созданные карты
			var fon:KadrFon = new KadrFon(Game.doc_x, Game.doc_y);
			addChild(fon);
			
			mini_maps_place = new Sprite  ;
			mini_maps = new Array  ;
			map_size_text = new Array  ;
			mst_format = new TextFormat();
			maps_ref = new FileReferenceList();
			i = -1;
			qx = Math.floor((Game.doc_x-20)/(Game.map_x+Game.mmd));//Количество мини-карт которое помещается в строке
			cmm = new Sprite  ;//Показывает, что выбрана именно эта карта
			
			cmm.graphics.lineStyle(2, 0x000099);
			cmm.graphics.drawRect(0, 0, 250, 250);
			
			addChild(mini_maps_place);
			
			urlLoaderMap = new Array;
			mapsCount = 0;
			
			statuser = new LoadStatuser(Game.doc_x/2 - 100, Game.doc_y/2 - 10, 200, 20);
		    addChild(statuser);
			
			load("maps_list.txt");
			
			statuser.setPos(10);
			
		}
		
		public function load(file:String) {
			urlRequest = new URLRequest("maps_list.txt");
			urlLoader = new URLLoader();
			urlLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
			urlLoader.load(urlRequest);
		}
		
		function urlLoader_complete(evt:Event):void {
			mapsCount = urlLoader.data.maps_count;
			cmm.x=(Game.map_x+Game.mmd)*((i+1)-qx*Math.floor((i+1)/qx))+20;
			cmm.y=(Game.map_x+Game.mmd+20)*Math.floor((i+1)/qx)+20;
			
			statuser.setPos(20);
			
			load_next_map();
		}
		
		function drawText(map_size:int) {
			mst_format=Formats.Static;
			mst_format.size=12;
			map_size_text[i].text="Карта размером "+map_size+" на "+map_size;
			map_size_text[i].setTextFormat(mst_format);
			map_size_text[i].x=(Game.map_x+Game.mmd)*(i-qx*Math.floor(i/qx))+20;
			map_size_text[i].y=(Game.map_x+Game.mmd+20)*Math.floor(i/qx);
			map_size_text[i].width=Game.map_x;
			map_size_text[i].height=20;
			map_size_text[i].background = true;
			map_size_text[i].backgroundColor = 0xcccccc;
			map_size_text[i].border = true;
			mini_maps[i].width=Game.map_x;
			mini_maps[i].height=Game.map_x;
			mini_maps[i].x=(Game.map_x+Game.mmd)*(i-qx*Math.floor(i/qx))+20;
			mini_maps[i].y=(Game.map_x+Game.mmd+20)*Math.floor(i/qx)+20;	
		}
		
		function maps_complete(evt:Event) {
			maps[i] = new StandartMap();
			loadMap();
		}
		
		function maps_completeGraphics(evt:Event) {
			maps[i] = new GraphicsMap();
			loadMap();
		}
		
		function loadMap() {
			mini_maps[i] = new Sprite;
			map_size_text[i] = new TextField;
			
			maps[i].load( urlLoaderMap[i] );
			maps[i].draw( mini_maps[i], Game.mini_cs);
			
			drawText(maps[i].width);
			load_next_map();
		}
		
		function load_next_map() {
			statuser.setPos(20 + (i+1)*80/mapsCount);
			if (i<mapsCount-1) {
				i+=1;
				
				//trace(i.toString() + ":" +urlLoader.data["map" + (i+1).toString()]);
				
				urlRequestMap = new URLRequest(urlLoader.data["map" + (i+1).toString()]);
				urlLoaderMap[i] = new URLLoader();
				urlLoaderMap[i].dataFormat = URLLoaderDataFormat.BINARY;
				
				//trace("type = " + urlLoader.data["map" + (i+1).toString() + "_type"]);
				if ( urlLoader.data["map" + (i+1).toString() + "_type"] == "graphics") {
					//Game.mapType = "graphics";
					urlLoaderMap[i].addEventListener(Event.COMPLETE, maps_completeGraphics);
				} else {
					//Game.mapType = "standart";
					urlLoaderMap[i].addEventListener(Event.COMPLETE, maps_complete);
				}
				
				urlLoaderMap[i].load(urlRequestMap);
		
			} else {
				finalize();
			}
		}
		
		function mm_click(event:MouseEvent) {
			for (var j:int=0; j<mini_maps.length; ++j) {
				if (mini_maps[j]==event.currentTarget) {
					i = j;
				}
			}
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
			
			removeChild(statuser);
		}
		
		function press_Ok_2(event:MouseEvent) {
			//trace("press_Ok_2 = " + i.toString());
			var k3:kadr_3 = new kadr_3(maps[i]);
			Game.setKadr(k3);
		}
		
	}
}