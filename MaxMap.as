package  {
	
	import MaxMain;
	import MaxScrollBar;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	public class MaxMap {

		var main:MaxMain;
		//Кнопки для маштабирования карты
		var zoomIn:Sprite;
		var zoomOut:Sprite;
		//положение на карте
		var txt_gor:TextField;
		var txt_vert:TextField;
		
		var map_rect:Rectangle;//Видимая часть карты
		//Меняю курсор только для карты
		var mc:Sprite;
		
		var map_size:int;
		var gor:int;
		var vert:int;
		var cell:Array;
		var map:Sprite;
		var map_units:Sprite;
		var map_place:Sprite;
		
		//Функция оптимизирующая затраты на графическую визуализацию
		var gor_start:int=new int  ;
		var vert_start:int=new int  ;
		var gor_length:int=new int  ;
		var vert_length:int=new int  ;
		
		var urlLoaderMap:Array;
		var i:int;
		
		var scrollbars:MaxScrollBar;
		var miniMap:MaxMiniMap;
				
		public function MaxMap(main_) {
			// constructor code
			main = main_;
	    }
			
		public function init() {
			main.fill_background();
			zoomIn=new Sprite;
			zoomOut=new Sprite;
			main.addChild(zoomIn);
			main.addChild(zoomOut);
			zoomIn.y=100;
			zoomIn.x=0;
			zoomOut.y=100;
			zoomOut.x=50;
			
			zoomIn.graphics.beginFill(0x777777);
			zoomIn.graphics.drawRect(0,0,50,20);
			//zoomIn.graphics.end();
			zoomOut.graphics.beginFill(0x777700);
			zoomOut.graphics.drawRect(0,0,50,20);
			//zoomOut.graphics.end();
			
			//interval+=100;
			zoomIn.addEventListener(MouseEvent.CLICK, plus_map);
			zoomOut.addEventListener(MouseEvent.CLICK, minus_map);
			
			//Создаем панель
			//var panel:Sprite=new Sprite  ;
			//var interval:int=0;
			
			//Определение клетки
			//interval+=20;
			txt_gor = new TextField;
			txt_vert = new TextField;
			txt_gor.defaultTextFormat=main.NORMAL;
			txt_gor.text="100";
			main.addChild(txt_gor);
			txt_gor.autoSize=TextFieldAutoSize.LEFT;
			txt_gor.width=txt_gor.width;
			txt_gor.autoSize=TextFieldAutoSize.NONE;
			txt_gor.y=50;
			txt_gor.border=true;
			txt_gor.background=true;
			txt_gor.backgroundColor=0x99FFCC;
			
			txt_vert.defaultTextFormat=main.NORMAL;
			txt_vert.text="100";
			main.addChild(txt_vert);
			txt_vert.autoSize=TextFieldAutoSize.LEFT;
			txt_vert.width=txt_vert.width;
			txt_vert.autoSize=TextFieldAutoSize.NONE;
			txt_vert.y=50;
			txt_vert.x=50;
			txt_vert.border=true;
			txt_vert.background=true;
			txt_vert.backgroundColor=0x99FFCC;
			
			urlLoaderMap = main.mapChoose.urlLoaderMap;
			i = main.mapChoose.i;
			
			//Создаем карту
			urlLoaderMap[i].data.position=0;
			map_size=urlLoaderMap[i].data.readInt();
			gor=new int  ;
			vert=new int  ;
			cell=new Array  ;
			map=new Sprite();
			map_units=new Sprite  ;
			map_place=new Sprite  ;
			
			//Функция оптимизирующая затраты на графическую визуализацию
			gor_start=new int  ;
			vert_start=new int  ;
			gor_length=new int  ;
			vert_length=new int  ;
			for (gor = 0; gor<map_size; gor++) {
				cell[gor]=new Array  ;
				for (vert = 0; vert<map_size; vert++) {
					cell[gor][vert] = new Array(
					"type",
					"optimize",
					"source_t",
					"source_n"
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
							map.graphics.beginBitmapFill(main.green_dark);
							map_units.graphics.beginBitmapFill(main.green);				
						} else if (cell[gor_start][vert_start]["type"]=="water") {
							map.graphics.beginBitmapFill(main.water_dark);
							map_units.graphics.beginBitmapFill(main.water);				
						} else if (cell[gor_start][vert_start]["type"]=="montain") {
							map.graphics.beginBitmapFill(main.montain_dark);
							map_units.graphics.beginBitmapFill(main.montain);				
						}			
						map.graphics.drawRect(gor_start*main.cell_pixels, vert_start*main.cell_pixels, main.cell_pixels*gor_length, main.cell_pixels*vert_length);
						map.graphics.endFill();
						map_units.graphics.drawRect(gor_start*main.cell_pixels, vert_start*main.cell_pixels, main.cell_pixels*gor_length, main.cell_pixels*vert_length);
						map_units.graphics.endFill();			
						vert=vert_start+vert_length-1;
						gor=gor_start;
					}
				}
			}
			
			
			//interval+=txt_gor.height+20;
			//map = new Sprite;
			//map_units = new Sprite;
			//map_place = new Sprite;
			map_rect = new Rectangle(0,0,main.visible_map_x,main.visible_map_y);
			
			main.addChild(map_place);
			map_place.addChild(map);
			map.addChild(map_units);
			map_place.x=main.map_x;
			map_place.scrollRect=map_rect;
			
			//Меняю курсор только для карты
			mc = new cursor_class  ;
			mc.mouseEnabled=false;
			map_place.addEventListener(MouseEvent.MOUSE_OVER, cursor_add);
			
			map_place.addEventListener(MouseEvent.MOUSE_MOVE,addtext);
			map_place.addEventListener(MouseEvent.ROLL_OUT,deltext);
			
			miniMap = new MaxMiniMap(main);
			scrollbars = new MaxScrollBar(main);
			
		}
		
		private function zoom_map() {
			map_place.scrollRect=map_rect;
			miniMap.mini_map.scaleX=1;
			miniMap.mini_map.scaleY=1;
			miniMap.border_mm.x= map_rect.x*miniMap.mini_map.width/map.width;
			miniMap.border_mm.y= map_rect.y*miniMap.mini_map.height/map.height;
			scrollbars.bar_box_gor.x= map_rect.x*scrollbars.box_button_gor.width/map.width;
			scrollbars.bar_box_vert.y= map_rect.y*scrollbars.box_button_vert.height/map.height;
			scrollbars.bar_box_gor.width=main.visible_map_x*scrollbars.box_button_gor.width/map.width;
			scrollbars.bar_box_vert.height=main.visible_map_y*scrollbars.box_button_vert.height/map.height;
			miniMap.border_mm.width=main.visible_map_x*miniMap.mini_map.width/map.width;
			miniMap.border_mm.height=main.visible_map_y*miniMap.mini_map.height/map.height;
			miniMap.mini_map.width=main.map_x;
			miniMap.mini_map.height=main.map_x;
		}
		
		private function minus_map(event:MouseEvent) {
			trace("minus_map");
			if (main.cell_size>13) {
				main.cell_size=main.cell_size/2;
				map.width=map.width/2;
				map.height=map.height/2;
				map_rect.x=map_rect.x/2-main.visible_map_x/4;
				map_rect.y=map_rect.y/2-main.visible_map_y/4;
				if (map_rect.x<0) {
					map_rect.x=0;
				}
				if (map_rect.x>map.width-main.visible_map_x) {
					map_rect.x=map.width-main.visible_map_x;
				}
				if (map_rect.y<0) {
					map_rect.y=0;
				}
				if (map_rect.y>map.height-main.visible_map_y) {
					map_rect.y=map.height-main.visible_map_y;
				}
				zoom_map();
			}
		}
		private function plus_map(event:MouseEvent) {
			trace("plus");
			if (main.cell_size<100) {
				main.cell_size=main.cell_size*2;
				map.width=map.width*2;
				map.height=map.height*2;
				map_rect.x=map_rect.x*2+main.visible_map_x/2;
				map_rect.y=map_rect.y*2+main.visible_map_y/2;
				zoom_map();
			}
		}
		
		private function cursor_add(event:MouseEvent) {
			Mouse.hide();
			main.addChild(mc);
			mc.x=event.stageX;
			mc.y=event.stageY;
			map_place.addEventListener(MouseEvent.MOUSE_MOVE, cursor_move);
			map_place.addEventListener(MouseEvent.MOUSE_OUT, cursor_del);
		}
		private function cursor_move(event:MouseEvent) {
			mc.x=event.stageX;
			mc.y=event.stageY;
		}
		private function cursor_del(event:MouseEvent) {
			Mouse.show();
			main.removeChild(mc);
			map_place.removeEventListener(MouseEvent.MOUSE_MOVE, cursor_move);
			map_place.removeEventListener(MouseEvent.MOUSE_OUT, cursor_del);
		}
		
		private function addtext(event:MouseEvent) {
			var gor:int=Math.floor((map_rect.x+main.stage.mouseX-map_place.x)/main.cell_size);
			gor+=1;
			txt_gor.text=gor.toString();
			var vert:int=Math.floor((map_rect.y+main.stage.mouseY-map_place.y)/main.cell_size);
			vert+=1;
			txt_vert.text=vert.toString();
		}
		private function deltext(event:MouseEvent) {
			txt_gor.text="";
			txt_vert.text="";
		}


	}
	
}
