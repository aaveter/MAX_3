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
			i =0;
			qx = Math.floor((Game.doc_x-20)/(Game.map_x+Game.mmd));//Количество мини-карт которое помещается в строке
			cmm =new Sprite  ;//Показывает, что выбрана именно эта карта
			
			cmm.graphics.lineStyle(2, 0x000099);
			cmm.graphics.drawRect(0, 0, 250, 250);
			
			addChild(mini_maps_place);
			
			urlRequest = new URLRequest("maps_list.txt");
			urlLoader = new URLLoader();
			urlLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
			urlLoader.load(urlRequest);
			
			mapsCount=0;
			
			urlLoaderMap=new Array;
		}		
		
		function urlLoader_complete(evt:Event):void {
			mapsCount=urlLoader.data.maps_count;
			//trace("mapsCount = " + mapsCount.toString());
			cmm.x=(Game.map_x+Game.mmd)*(i-qx*Math.floor(i/qx))+20;
			cmm.y=(Game.map_x+Game.mmd+20)*Math.floor(i/qx)+20;
			urlRequestMap = new URLRequest(urlLoader.data["map" + (i+1).toString()]);
			urlLoaderMap[i] = new URLLoader();
			urlLoaderMap[i].dataFormat=URLLoaderDataFormat.BINARY;
			urlLoaderMap[i].addEventListener(Event.COMPLETE, maps_complete);
			urlLoaderMap[i].load(urlRequestMap);
		}
		
		function maps_complete(evt:Event) {
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
		
			if (i<mapsCount-1) {
				i+=1;
		
				urlRequestMap = new URLRequest(urlLoader.data["map" + (i+1).toString()]);
				urlLoaderMap[i] = new URLLoader();
				urlLoaderMap[i].dataFormat=URLLoaderDataFormat.BINARY;
				urlLoaderMap[i].addEventListener(Event.COMPLETE, maps_complete);
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
			var k3:kadr_3=new kadr_3(urlLoaderMap[i]);
			Game.setKadr(k3);
		}
		
	}
}