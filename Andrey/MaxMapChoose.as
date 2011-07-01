package  {
	
	import MaxMain;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.net.FileReferenceList;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	
	public class MaxMapChoose {

		var main:MaxMain;
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

		public function MaxMapChoose(main_) {
			// constructor code
			main = main_;
			
			//Загружаю все созданные карты
			mini_maps_place =new Sprite  ;
			mini_maps =new Array  ;
			map_size_text =new Array  ;
			mst_format = new TextFormat();
			maps_ref =new FileReferenceList();
			i =0;
			qx = Math.floor((main.doc_x-20)/(main.map_x+main.mmd));//Количество мини-карт которое помещается в строке
			cmm =new Sprite  ;//Показывает, что выбрана именно эта карта
			
			cmm.graphics.lineStyle(2, 0x000099);
			cmm.graphics.drawRect(0, 0, 250, 250);
			
			main.addChild(mini_maps_place);
			
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
			trace("mapsCount = " + mapsCount.toString());
			cmm.x=(main.map_x+main.mmd)*(i-qx*Math.floor(i/qx))+20;
			cmm.y=(main.map_x+main.mmd+20)*Math.floor(i/qx)+20;
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
							mini_maps[i].graphics.beginBitmapFill(main.mini_green);
						} else if (cell[gor_start][vert_start]["type"]=="water") {
							mini_maps[i].graphics.beginBitmapFill(main.mini_water);
						} else if (cell[gor_start][vert_start]["type"]=="montain") {
							mini_maps[i].graphics.beginBitmapFill(main.mini_montain);
						}
						mini_maps[i].graphics.drawRect(gor_start*main.mini_cs,vert_start*main.mini_cs,main.mini_cs*gor_length,main.mini_cs*vert_length);
						mini_maps[i].graphics.endFill();
						vert=vert_start+vert_length-1;
						gor=gor_start;
					}
				}
			}
			mst_format=main.STATIC_text;
			mst_format.size=12;
			map_size_text[i].text="Карта размером "+map_size+" на "+map_size;
			map_size_text[i].setTextFormat(mst_format);
			map_size_text[i].x=(main.map_x+main.mmd)*(i-qx*Math.floor(i/qx))+20;
			map_size_text[i].y=(main.map_x+main.mmd+20)*Math.floor(i/qx);
			map_size_text[i].width=main.map_x;
			map_size_text[i].height=20;
			mini_maps[i].width=main.map_x;
			mini_maps[i].height=main.map_x;
			mini_maps[i].x=(main.map_x+main.mmd)*(i-qx*Math.floor(i/qx))+20;
			mini_maps[i].y=(main.map_x+main.mmd+20)*Math.floor(i/qx)+20;	
		
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
			i=Math.floor((main.mouseX()-mini_maps_place.x)/(main.map_x+main.mmd))
				+qx*Math.floor((main.mouseY()-mini_maps_place.y)/(main.map_x+main.mmd));
			cmm.x=(main.map_x+main.mmd)*(i-qx*Math.floor(i/qx))+20;
			cmm.y=(main.map_x+main.mmd+20)*Math.floor(i/qx)+20;
		}
		
		function finalize() {
			for (i=0; i<mini_maps.length; i++) {
				mini_maps[i].addEventListener(MouseEvent.CLICK,mm_click);
				mini_maps_place.addChild(mini_maps[i]);
				mini_maps_place.addChild(map_size_text[i]);
			}
			mini_maps_place.addChild(cmm);
			i=0;
			var Ok_2=new Ok_class  ;
			main.addChild(Ok_2);
			Ok_2.x=(main.doc_x-Ok_2.width)/2;
			Ok_2.y=main.doc_y-Ok_2.height-100;
			Ok_2.addEventListener(MouseEvent.CLICK, press_Ok_2);
		}
		
		function press_Ok_2(event:MouseEvent) {
			//Удаляю предидущий кадр
			while (main.numChildren() != 0) {
				main.removeChildAt(main.numChildren()-1);
			}
			main.next();//gotoAndStop(3);
		}

	}
	
}
