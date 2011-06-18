package  {
	
	import MaxMain;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.net.FileReferenceList;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	
	public class MaxScrollBar {
		var main:MaxMain;
		//Вертикальная строка прокрутки карты передвижения стрелками
		var scrollbar_vert_map:Sprite=new Sprite  ;
		var arrow_up:Sprite=new Arrow  ;
		var arrow_down:Sprite=new Arrow  ;
		var scrollbar_border_vert:Shape=new Shape  ;
		var scrollbar_bg_vert:Shape=new Shape  ;
		var box_vert:Sprite=new Sprite  ;
		var box_button_vert:Sprite=new Button_press_class2  ;
		var bar_box_vert:Sprite=new bar_box  ;
		
		//Горизонтальная строка прокрутки карты передвижения стрелками
		var scrollbar_gor_map:Sprite=new Sprite  ;
		var arrow_left:Sprite=new Arrow  ;
		var arrow_right:Sprite=new Arrow  ;
		var scrollbar_border_gor:Shape=new Shape  ;
		var scrollbar_bg_gor:Shape=new Shape  ;
		var box_gor:Sprite=new Sprite  ;
		var box_button_gor:Sprite=new Button_press_class2  ;
		var bar_box_gor:Sprite=new bar_box  ;
		
		var mini_map:Sprite;
		var map:Sprite;

		public function MaxScrollBar(main_) {
			// constructor code
			main = main_;
			map = main.map.map;
			mini_map = main.map.miniMap.mini_map;
			arrow_up.rotation=180;
			arrow_left.rotation=90;
			arrow_right.rotation=-90;
			
			scrollbar_vert_add();
			scrollbar_gor_add();
		}
		
		function scrollbar_vert_add() {
			scrollbar_vert_map.x=main.map.map_place.x+main.visible_map_x;
			scrollbar_vert_map.y=main.map.map_place.y;
			main.addChild(scrollbar_vert_map);
			scrollbar_vert_map.addChild(arrow_up);
			scrollbar_vert_map.addChild(arrow_down);
			scrollbar_vert_map.addChild(scrollbar_border_vert);
			scrollbar_vert_map.addChild(box_vert);
			scrollbar_border_vert.graphics.lineStyle(2, 0x0000FF);
			scrollbar_border_vert.graphics.moveTo(1,arrow_up.height);
			scrollbar_border_vert.graphics.lineTo(1,main.visible_map_y-arrow_down.height);
			scrollbar_border_vert.graphics.moveTo(arrow_up.width-1,arrow_up.height);
			scrollbar_border_vert.graphics.lineTo(arrow_up.width-1,main.visible_map_y-arrow_down.height);
		
			arrow_up.x=arrow_up.width/2;
			arrow_up.y=arrow_up.height/2;
			arrow_up.buttonMode=true;
			arrow_down.x=arrow_down.width/2;
			arrow_down.y=main.visible_map_y-arrow_up.height/2;
			arrow_down.buttonMode=true;
		
			box_vert.x=2;
			box_vert.y=arrow_up.width;
			box_vert.addChild(bar_box_vert);
			box_vert.addChild(box_button_vert);
			box_button_vert.width=arrow_down.width-4;
			box_button_vert.height=main.visible_map_y-arrow_down.height*2;
			bar_box_vert.width=arrow_down.width-4;
			bar_box_vert.height=main.visible_map_y*box_button_vert.height/main.map.map.height;
		
			arrow_up.addEventListener(MouseEvent.CLICK,arrow_up_animation);
			arrow_down.addEventListener(MouseEvent.CLICK,arrow_down_animation);
			function arrow_up_animation(event:MouseEvent) {
				mini_map.scaleY=1;
				if (main.map.map_rect.y-main.cell_size>=0) {
					main.map.map_rect.y-=main.cell_size;			
				} else {
					main.map.map_rect.y=0;			
				}
				main.map.miniMap.border_mm.y=main.map.map_rect.y*mini_map.height/map.height;
				bar_box_vert.y=main.map.map_rect.y*box_button_vert.height/map.height;
				main.map.map_place.scrollRect=main.map.map_rect;
				mini_map.height=main.map_x;
			}
			function arrow_down_animation(event:MouseEvent) {		
				mini_map.scaleY=1;
				if (main.map.map_rect.y+main.cell_size<main.map.map.height-main.visible_map_y) {
					main.map.map_rect.y+=main.cell_size;			
				} else {
					main.map.map_rect.y=main.map.map.height-main.visible_map_y;			
				}
				main.map.miniMap.border_mm.y=main.map.map_rect.y*mini_map.height/map.height;
				bar_box_vert.y=main.map.map_rect.y*box_button_vert.height/map.height;
				main.map.map_place.scrollRect=main.map.map_rect;
				mini_map.height=main.map_x;
			}
		
			//Передвижение bar за мышкой (вертикальная строка)
			function bb_move_vert() {
				mini_map.scaleY=1;
				if (main.mouseY()-scrollbar_vert_map.y-box_vert.y-bar_box_vert.height/2<0) {
					bar_box_vert.y=0;						
				} else if (main.mouseY()-scrollbar_vert_map.y-box_vert.y-bar_box_vert.height/2>box_button_vert.height-bar_box_vert.height) {
					bar_box_vert.y=box_button_vert.height-bar_box_vert.height;					
				} else {
					bar_box_vert.y=main.mouseY()-scrollbar_vert_map.y-box_vert.y-bar_box_vert.height/2;					
				}
				main.map.map_rect.y=bar_box_vert.y*map.height/box_button_vert.height;
				main.map.miniMap.border_mm.y=main.map.map_rect.y*mini_map.height/map.height;		
				main.map.map_place.scrollRect=main.map.map_rect;
				mini_map.height=main.map_x;
			}
			box_button_vert.addEventListener(MouseEvent.MOUSE_DOWN,bb_vert_down);
			function bb_vert_down(event:MouseEvent) {
				bb_move_vert();
				box_button_vert.addEventListener(MouseEvent.MOUSE_MOVE,bb_vert_move);
				function bb_vert_move(event:MouseEvent) {
					bb_move_vert();
				}
				box_button_vert.addEventListener(MouseEvent.MOUSE_UP,bb_vert_stop);
				box_button_vert.addEventListener(MouseEvent.MOUSE_OUT,bb_vert_stop);
				function bb_vert_stop(event:MouseEvent) {
					box_button_vert.removeEventListener(MouseEvent.MOUSE_MOVE,bb_vert_move);
				}
			}
		}
		
		function scrollbar_gor_add() {
			scrollbar_gor_map.x=main.map.map_place.x;
			scrollbar_gor_map.y=main.map.map_place.y+main.visible_map_y;
			main.addChild(scrollbar_gor_map);
			scrollbar_gor_map.addChild(arrow_left);
			scrollbar_gor_map.addChild(arrow_right);
			scrollbar_gor_map.addChild(scrollbar_border_gor);
			scrollbar_gor_map.addChild(box_gor);
			scrollbar_border_gor.graphics.lineStyle(2, 0x0000FF);
			scrollbar_border_gor.graphics.moveTo(arrow_left.width,1);
			scrollbar_border_gor.graphics.lineTo(main.visible_map_x-arrow_left.width,1);
			scrollbar_border_gor.graphics.moveTo(arrow_left.width,arrow_left.height-1);
			scrollbar_border_gor.graphics.lineTo(main.visible_map_x-arrow_left.width,arrow_left.height-1);
		
			arrow_left.x=arrow_left.width/2;
			arrow_left.y=arrow_left.height/2;
			arrow_left.buttonMode=true;
			arrow_right.x=main.visible_map_x-arrow_right.width/2;
			arrow_right.y=arrow_left.height/2;
			arrow_right.buttonMode=true;
		
			box_gor.x=arrow_left.width;
			box_gor.y=2;
			box_gor.addChild(bar_box_gor);
			box_gor.addChild(box_button_gor);
			box_button_gor.width=main.visible_map_x-arrow_right.width*2;
			box_button_gor.height=arrow_right.height-4;
			bar_box_gor.width=main.visible_map_x*box_button_gor.width/map.width;
			bar_box_gor.height=arrow_right.height-4;
		
			arrow_left.addEventListener(MouseEvent.CLICK,arrow_left_animation);
			arrow_right.addEventListener(MouseEvent.CLICK,arrow_right_animation);
			function arrow_left_animation(event:MouseEvent) {
				mini_map.scaleX=1;
				if (main.map.map_rect.x-main.cell_size>=0) {
					main.map.map_rect.x-=main.cell_size;
				} else {
					main.map.map_rect.x=0;
				}
				main.map.miniMap.border_mm.x=main.map.map_rect.x*mini_map.width/map.width;
				bar_box_gor.x=main.map.map_rect.x*box_button_gor.width/map.width;
				main.map.map_place.scrollRect=main.map.map_rect;
				mini_map.width=main.map_x;
			}
			function arrow_right_animation(event:MouseEvent) {
				mini_map.scaleX=1;
				if (main.map.map_rect.x+main.cell_size<map.width-main.visible_map_x) {
					main.map.map_rect.x+=main.cell_size;
				} else {
					main.map.map_rect.x=map.width-main.visible_map_x;
				}
				main.map.miniMap.border_mm.x=main.map.map_rect.x*mini_map.width/map.width;
				bar_box_gor.x=main.map.map_rect.x*box_button_gor.width/map.width;
				main.map.map_place.scrollRect=main.map.map_rect;
				mini_map.width=main.map_x;
			}
		
			//Передвижение bar за мышкой (горизонтальная строка)
			function bb_move_gor() {
				mini_map.scaleX=1;
				if (main.mouseX()-scrollbar_gor_map.x-box_gor.x-bar_box_gor.width/2<0) {
					bar_box_gor.x=0;			
				} else if (main.mouseX()-scrollbar_gor_map.x-box_gor.x-bar_box_gor.width/2>box_button_gor.width-bar_box_gor.width) {
					bar_box_gor.x=box_button_gor.width-bar_box_gor.width;			
				} else {
					bar_box_gor.x=main.mouseX()-scrollbar_gor_map.x-box_gor.x-bar_box_gor.width/2;			
				}
				main.map.map_rect.x=bar_box_gor.x*map.width/box_button_gor.width;
				main.map.miniMap.border_mm.x=main.map.map_rect.x*mini_map.width/map.width;
				main.map.map_place.scrollRect=main.map.map_rect;
				mini_map.width=main.map_x;
			}
			box_button_gor.addEventListener(MouseEvent.MOUSE_DOWN,bb_gor_down);
			function bb_gor_down(event:MouseEvent) {
				bb_move_gor();
				box_button_gor.addEventListener(MouseEvent.MOUSE_MOVE,bb_gor_move);
				function bb_gor_move(event:MouseEvent) {
					bb_move_gor();
				}
				box_button_gor.addEventListener(MouseEvent.MOUSE_UP,bb_gor_stop);
				box_button_gor.addEventListener(MouseEvent.MOUSE_OUT,bb_gor_stop);
				function bb_gor_stop(event:MouseEvent) {
					box_button_gor.removeEventListener(MouseEvent.MOUSE_MOVE,bb_gor_move);
				}
			}
		}

	}
	
}
