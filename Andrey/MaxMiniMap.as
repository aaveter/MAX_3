package  {
	
	import MaxMain;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class MaxMiniMap {

		var main:MaxMain;
		var mini_map:Sprite;
		var border_mm:Sprite;
		//var cell:Array;
		//var map:Sprite;

		public function MaxMiniMap(main_) {
			// constructor code
			main = main_;
			//map = main.map.map;
			//cell = main.map.cell;
			mini_map=new Sprite  ;
			border_mm=new border_class  ;
			
			main.addChild(mini_map);
			create_mini_map();
		}
		
		function create_mini_map() {
			mini_map.y=300;	
			var gor_start:int=new int  ;
			var vert_start:int=new int  ;
			var gor_length:int=new int  ;
			var vert_length:int=new int  ;
			for (var gor:int = 0; gor<main.map.map_size; gor++) {
				for (var vert:int = 0; vert<main.map.map_size; vert++) {
					main.map.cell[gor][vert]["optimize"]=0;
				}
			}
			for (gor = 0; gor<main.map.map_size; gor++) {
				gor_start=gor;
				for (vert = 0; vert<main.map.map_size; vert++) {
					gor_length=1;
					vert_start=vert;
					vert_length=1;
					if (main.map.cell[gor][vert]["optimize"]!=1) {				
						main.map.cell[gor][vert]["optimize"]=1;
						while (vert<main.map.map_size-1 && 
							   main.map.cell[gor][vert]["type"]==main.map.cell[gor][vert+1]["type"] && 
							   main.map.cell[gor][vert+1]["optimize"]!=1) 
						{
							vert_length+=1;
							vert+=1;
							main.map.cell[gor][vert]["optimize"]=1;
						}
						vert=vert_start;
						while (gor<main.map.map_size-1&&main.map.cell[gor][vert]["type"]==main.map.cell[gor+1][vert]["type"]&&vert_start+vert_length>vert) {
							vert+=1;
							if (vert_start+vert_length==vert) {
								gor_length+=1;
								gor+=1;
								for (vert = vert_start; vert_start+vert_length>vert; vert++) {
									main.map.cell[gor][vert]["optimize"]=1;
								}
								vert=vert_start;
							}
						}
						if (main.map.cell[gor_start][vert_start]["type"]=="green") {
							mini_map.graphics.beginBitmapFill(main.mini_green);
						} else if (main.map.cell[gor_start][vert_start]["type"]=="water") {
							mini_map.graphics.beginBitmapFill(main.mini_water);
						} else if (main.map.cell[gor_start][vert_start]["type"]=="montain") {
							mini_map.graphics.beginBitmapFill(main.mini_montain);
						}
						mini_map.graphics.drawRect(gor_start*main.mini_cs,
												   vert_start*main.mini_cs,
												   main.mini_cs*gor_length,
												   main.mini_cs*vert_length);
						mini_map.graphics.endFill();
						vert=vert_start+vert_length-1;
						gor=gor_start;
					}
				}
			}
			mini_map.addChild(border_mm);
			border_mm.width=main.visible_map_x*mini_map.width/main.map.map.width;
			border_mm.height=main.visible_map_y*mini_map.height/main.map.map.height;
			mini_map.width=main.map_x;
			mini_map.height=main.map_y;
		
			//Передвижение по мини-карте
			function mini_move_gor() {
				var mouse_x:int = (main.mouseX()-mini_map.x)*mini_map.width/main.map_x;
				if (mouse_x-border_mm.width/2<0) {
					border_mm.x=0;
				} else if (mouse_x-border_mm.width/2>mini_map.width-border_mm.width) {
					border_mm.x=mini_map.width-border_mm.width;
				} else {
					border_mm.x=mouse_x-border_mm.width/2;
				}
				main.map.map_rect.x=border_mm.x*main.map.map.width/mini_map.width;
				main.map.scrollbars.bar_box_gor.x=main.map.map_rect.x*
							main.map.scrollbars.box_button_gor.width/main.map.map.width;
			}
			function mini_move_vert() {
				var mouse_y:int = (main.mouseY()-mini_map.y)*mini_map.height/main.map_x;
				if (mouse_y-border_mm.height/2<0) {
					border_mm.y=0;
				} else if (mouse_y-border_mm.height/2>mini_map.height-border_mm.height) {
					border_mm.y=mini_map.height-border_mm.height;
				} else {
					border_mm.y=mouse_y-border_mm.height/2;
				}
				main.map.map_rect.y=border_mm.y*main.map.map.height/mini_map.height;
				main.map.scrollbars.bar_box_vert.y=main.map.map_rect.y*
							main.map.scrollbars.box_button_vert.height/main.map.map.height;
			}
			mini_map.addEventListener(MouseEvent.MOUSE_DOWN,mini_down);
			function mini_down(event:MouseEvent) {
				main.map.map_rect=new Rectangle(0,0,main.visible_map_x,main.visible_map_y);
				mini_move();
				mini_map.addEventListener(MouseEvent.MOUSE_MOVE,mini_moving);
				function mini_moving(event:MouseEvent) {
					mini_move();
				}
				function mini_move() {
					mini_map.scaleX=1;
					mini_map.scaleY=1;
					mini_move_gor();
					mini_move_vert();
					main.map.map_place.scrollRect=main.map.map_rect;
					mini_map.width=main.map_x;
					mini_map.height=main.map_y;
				}
				mini_map.addEventListener(MouseEvent.MOUSE_UP,mini_stop);
				mini_map.addEventListener(MouseEvent.MOUSE_OUT,mini_stop);
				function mini_stop(event:MouseEvent) {
					mini_map.removeEventListener(MouseEvent.MOUSE_MOVE,mini_moving);
					mini_map.removeEventListener(MouseEvent.MOUSE_UP,mini_stop);
					mini_map.removeEventListener(MouseEvent.MOUSE_OUT,mini_stop);
				}
			}
		}

	}
	
}
