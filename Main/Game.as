package Main
{
	import flash.geom.Rectangle;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.events.Event;

	public class Game extends Sprite
	{
		public static const map_scroll:int = 1;//Размер сдвига при прокрутки карты
		public static const map_x:int = 250;//Карта сдвинаута по x
		public static const map_y:int = 0;//Карта сдвинаута по y
		public static const cell_pixels:int = 100;//Количество пикселей из которого состоит клетка.
		public static const mini_cs:int = 4;//Размер одной клетки на мини-карте в пикселях.
		public static const pd:Number = 10;//Минимальное расстояние между игроками
		public static const mmd:int = 10;//Расстояние между мини-картами при выборе карты для игры
		public static const green:BitmapData=new green_class(0,0)
		public static const water:BitmapData=new water_class(0,0)
		public static const montain:BitmapData=new montain_class(0,0)
		public static const green_dark:BitmapData=new green_dark_class(0,0)
		public static const water_dark:BitmapData=new water_dark_class(0,0)
		public static const montain_dark:BitmapData=new montain_dark_class(0,0)
		public static var cell_size = cell_pixels;//Размер клетки изначальна она равна кол-ву пикселей, но при маштабировании будет меняться.
		public static var step:int = 0;//Указывает номер хода в игре

		public static var visible_map_x:int = 700;//Размер показываемой карты по X
		public static var visible_map_y:int = 700;//Размер показываемой карты по Y
		public static var map_rect:Rectangle = new Rectangle(0,0,10,10);//Видимая часть карты
		public var doc_x:int = 100;//Размер документа по x
		public var doc_y:int = 100;//Размер документа по 

		//var resize_obj = {};
		private var stage_:Stage;

		public function Game(main:Stage)
		{
			stage_ = main;
			stage_.scaleMode="noScale";
			stage_.align="TL";
			doc_x = stage_.stageWidth;//Размер документа по x
			doc_y = stage_.stageHeight;//Размер документа по y
			stage_.addEventListener(Event.RESIZE,resize_main);
		}
		
		function resize_main(ev:Event) {
			doc_x = stage_.stageWidth;//Размер документа по x
			doc_y = stage_.stageHeight;//Размер документа по y
			visible_map_x = doc_x - map_x;
			visible_map_y = doc_y - map_y - 50;
			map_rect.width = visible_map_x;
			map_rect.height = visible_map_y;
			trace(visible_map_x);
			trace(visible_map_y);
		}
		
		public function clear_game()
		{
			while (numChildren != 0)
			{
				removeChildAt(numChildren-1);
			}
		}
	}
}