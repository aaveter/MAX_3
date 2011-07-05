package Andrey {
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import Andrey.MaxPlayersChoose;
	import Andrey.MaxMapChoose;
	import Andrey.MaxMap;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.BitmapData;
	
	public class MaxMain {

		var stage:Stage;
		var playersChoose:MaxPlayersChoose;
		var mapChoose:MaxMapChoose;
		var map:MaxMap;
		//Форматы текстов
		var Black_text:TextFormat;
		var INPUT_text:TextFormat;
		var STATIC_text:TextFormat;
		var NORMAL:TextFormat;
		
		//Список всех констант для изменения
		var doc_x:int;//1200;//Размер документа по x
		var doc_y:int;//Размер документа по y
		var map_scroll:int;//Размер сдвига при прокрутки карты
		var visible_map_x:int;//Размер показываемой карты
		var visible_map_y:int;//Размер показываемой карты
		var map_x:int;
		var map_y:int;
		var cell_pixels:int;//Количество пикселей из которого состоит клетка.
		var cell_size;//Размер клетки изначальна она равна кол-ву пикселей, но при маштабировании будет меняться.
		var mini_cs:int;//Размер одной клетки на мини-карте в пикселях.
		
		var green:BitmapData;//Трава
		var water:BitmapData;//Вода
		var montain:BitmapData;//Гора
		var green_dark:BitmapData;//Трава
		var water_dark:BitmapData;//Вода
		var montain_dark:BitmapData;//Гора
		var mini_green:BitmapData;
		var mini_water:BitmapData;
		var mini_montain:BitmapData;
		
		var pd:int;//Минимальное расстояние между игроками
		var mmd:int;//Расстояние между мини-картами при выборе карты для игры
		//var map_rect:Rectangle=new Rectangle(0,0,visible_map_x,visible_map_y);//Видимая часть карты
		var step:int;
		//Конец списка констант

		//Переменные определяющие сканируемые зоны
		var scan_zone:Sprite;//Вся зона
		var scan_area:Array;//Массив отдельных видимых областей соответствует юнитам и зданиям игрока
		
		//Константы для централизации текста в button_class
		var wmb:int;
		var wab:int;
		var x_shift_b:int;
		var y_shift_b:int;
		//Конец списка констант для централизации текста в button_class
		
		//Массив кнопок button_class с текстом и функция по настройке текста
		var bp_array:Array;
		var b_array:Array;
		var bt_array:Array;
		var spec_text:String;
		var spec_format:TextFormat;
		var Int:int;
		var ai:int;
		var kadr:int;

		public function MaxMain(stage_) {
			// constructor 
			stage = stage_;
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.SHOW_ALL;
			trace("MaxMain ok!");
							
			kadr = 0;
							
			Black_text = new TextFormat();
			INPUT_text = new TextFormat();
			STATIC_text = new TextFormat();
			NORMAL = new TextFormat();
			
			INPUT_text.bold=true;
			INPUT_text.size=18;
			INPUT_text.font="Tahoma";
			INPUT_text.color=0x000099;
			INPUT_text.align=TextFormatAlign.LEFT;
			
			STATIC_text.bold=true;
			STATIC_text.size=18;
			STATIC_text.font="Tahoma";
			STATIC_text.color=0x999999;
			STATIC_text.align=TextFormatAlign.CENTER;
			
			Black_text.bold=true;
			Black_text.size=35;
			Black_text.font="Tahoma";
			Black_text.color=0x000000;
			Black_text.align=TextFormatAlign.CENTER;
			
			NORMAL.align=TextFormatAlign.CENTER;
			NORMAL.font="Tahoma";
			NORMAL.size=20;
			NORMAL.bold=true;
			//Конец формата текстов
			
			green =new green_class(0,0);//Трава
			water =new water_class(0,0);//Вода
			montain =new montain_class(0,0);//Гора
			green_dark =new green_dark_class(0,0);//Трава
			water_dark =new water_dark_class(0,0);//Вода
			montain_dark =new montain_dark_class(0,0);//Гора			
			
			//Список всех констант для изменения
			doc_x = stage.stageWidth;//1200;//Размер документа по x
			doc_y = stage.stageHeight;//Размер документа по y
			trace("doc_x="+doc_x.toString()+" doc_y="+doc_y.toString());
			map_scroll = 1;//Размер сдвига при прокрутки карты
			visible_map_x = doc_x-50;//Размер показываемой карты
			visible_map_y =doc_y-50;//Размер показываемой карты
			map_x =250;
			map_y =0;
			cell_pixels =100;//Количество пикселей из которого состоит клетка.
			cell_size=cell_pixels;//Размер клетки изначальна она равна кол-ву пикселей, но при маштабировании будет меняться.
			mini_cs =4;//Размер одной клетки на мини-карте в пикселях.
			//var green:BitmapData=new green_class(0,0);//Трава
			//var water:BitmapData=new water_class(0,0);//Вода
			//var montain:BitmapData=new montain_class(0,0);//Гора
			//var green_dark:BitmapData=new green_dark_class(0,0);//Трава
			//var water_dark:BitmapData=new water_dark_class(0,0);//Вода
			//var montain_dark:BitmapData=new montain_dark_class(0,0);//Гора
			//var mini_green:BitmapData=new mini_green_class(0,0);
			//var mini_water:BitmapData=new mini_water_class(0,0);
			//var mini_montain:BitmapData=new mini_montain_class(0,0);
			pd=10;//Минимальное расстояние между игроками
			mmd=10;//Расстояние между мини-картами при выборе карты для игры
			//var map_rect:Rectangle=new Rectangle(0,0,visible_map_x,visible_map_y);//Видимая часть карты
			step=0;
			//Конец списка констант
	
			//Переменные определяющие сканируемые зоны
			scan_zone=new Sprite  ;//Вся зона
			scan_area=new Array  ;//Массив отдельных видимых областей соответствует юнитам и зданиям игрока
			
			//Константы для централизации текста в button_class
			wmb=75;
			wab=83.5;
			x_shift_b=2;
			y_shift_b=3.5;
			//Конец списка констант для централизации текста в button_class
			
			//Массив кнопок button_class с текстом и функция по настройке текста
			var bp_array:Array=new Array  ;
			var b_array:Array=new Array  ;
			var bt_array:Array=new Array  ;
			var spec_text:String=new String  ;
			var spec_format:TextFormat=STATIC_text;
			var Int:int=40;
			var ai:int=0;
			
			
			var pole:Sprite = new Sprite();
			var matr:Matrix = new Matrix(); /// для задания одного из параметров заливки нам понадобиться матрица, тут мы ее создаем
			matr.createGradientBox(1200, 1000, 90, 0, 0); /// тут мы определям ее размеры, вращение и координаты
			pole.graphics.lineStyle(2);
							 /// тип градиента, массивы для цвета, прозрачности, расположения цветов, задание матрицы   
			pole.graphics.beginGradientFill(GradientType.LINEAR, [0xEEFFEE, 0x669966], [1, 1], [50, 255], matr, SpreadMethod.REFLECT);
			pole.graphics.drawRect(0,0,1200,1000);
			pole.graphics.endFill();
			stage.addChild(pole);
			
			//pole.alpha = 30;
			
			
			//var sp:Sprite = new Sprite;
			//sp.graphics.beginFill(0x999999);
			//sp.graphics.drawRect(0,0,1200,1000);
			//stage.addChild(sp);
			
			playersChoose = new MaxPlayersChoose(this);
		}
		
		function addChild(obj){
			stage.addChild(obj);
		}
		
		function removeChild(obj) {
			stage.removeChild(obj);
		}
		
		function removeChildAt(num:int) {
			stage.removeChildAt(num);
		}
		
		function next() {
			kadr = kadr + 1;
			if (kadr == 1) {
				mapChoose = new MaxMapChoose(this);
			} else if (kadr == 2) {
				map = new MaxMap(this);
				map.init();
			}
		}
		
		function numChildren():int {
			return stage.numChildren;
		}
		
		function mouseX():int {
			return stage.mouseX;
		}
		
		function mouseY():int {
			return stage.mouseY;
		}

	}
	
}
