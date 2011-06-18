package  {
	
	import MaxMain;
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
		
		var map:Sprite=new Sprite();
		var map_units:Sprite=new Sprite  ;
		var map_place:Sprite=new Sprite  ;
		
		var map_rect:Rectangle;//Видимая часть карты
		//Меняю курсор только для карты
		var mc:Sprite;
				
		public function MaxMap(main_) {
			// constructor code
			main = main_;
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
			
			//interval+=txt_gor.height+20;
			map = new Sprite;
			map_units = new Sprite;
			map_place = new Sprite;
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
		}
		
		private function zoom_map() {
			map_place.scrollRect=map_rect;
			//mini_map.scaleX=1;
			//mini_map.scaleY=1;
			//border_mm.x=map_rect.x*mini_map.width/map.width;
			//border_mm.y=map_rect.y*mini_map.height/map.height;
			//bar_box_gor.x=map_rect.x*box_button_gor.width/map.width;
			//bar_box_vert.y=map_rect.y*box_button_vert.height/map.height;
			//bar_box_gor.width=visible_map_x*box_button_gor.width/map.width;
			//bar_box_vert.height=visible_map_y*box_button_vert.height/map.height;
			//border_mm.width=visible_map_x*mini_map.width/map.width;
			//border_mm.height=visible_map_y*mini_map.height/map.height;
			//mini_map.width=map_x;
			//mini_map.height=map_x;
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
