package Main
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class base_params
	{		
		public static const map_scroll:int = 1;//Размер сдвига при прокрутки карты
		public static const visible_map_x:int = 700;//Размер показываемой карты по X
		public static const visible_map_y:int = 700;//Размер показываемой карты по Y
		public static const map_x:int = 250;//Карта сдвинаута по x
		public static const map_y:int = 0;//Карта сдвинаута по y
		public static const cell_pixels:int = 100;//Количество пикселей из которого состоит клетка.
		public static const mini_cs:int = 4;//Размер одной клетки на мини-карте в пикселях.
		public static const pd:Number = 10;//Минимальное расстояние между игроками
		public static const mmd:int = 10;//Расстояние между мини-картами при выборе карты для игры
		public static var stage;//Сцена в которую все добавляем
		public static var doc_x;//Размер документа по x
		public static var doc_y;//Размер документа по y
		public static var cell_size = cell_pixels;//Размер клетки изначальна она равна кол-ву пикселей, но при маштабировании будет меняться.
		public static var map_rect:Rectangle = new Rectangle(0,0,visible_map_x,visible_map_y);//Видимая часть карты
		public static var step:int = 0;//Указывает номер хода в игре
		//static var green:BitmapData = new green_class(0,0);//Трава
		//static var water:BitmapData = new water_class(0,0);//Вода
		//static var montain:BitmapData = new montain_class(0,0);//Гора
		//static var green_dark:BitmapData = new green_dark_class(0,0);//Трава
		//static var water_dark:BitmapData = new water_dark_class(0,0);//Вода
		//static var montain_dark:BitmapData = new montain_dark_class(0,0);//Гора

		public function base_params(main)
		{
			stage = main
			doc_x = main.stageWidth;//Размер документа по x
			doc_y = main.stageHeight;//Размер документа по y
		}
	}
}