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
		public static var doc_x:int = 100;//Размер документа по x
		public static var doc_y:int = 100;//Размер документа по 

		private static var stage_:Stage = null; // ссылка на сцену
		private static var kadr_:Sprite = null; // ссылка на текущий кадр
		private static var game_:Game = null; // ссылка на себя саму

		public function Game(main:Stage)
		{
			game_ = this;
			stage_ = main;
			stage_.scaleMode="noScale"; // чтобы получать событие изменения размера
			stage_.align="TL"; // пусть сцена выравнивается по левому и правому краю
			refreshSizes();
			stage_.addEventListener(Event.RESIZE,resize_main);
		}
		
		// обновляем размеры: обновляем глобальные переменные и размеры кадра
		public function refreshSizes() {
			doc_x = stage_.stageWidth; //обновляем размер документа по x
			doc_y = stage_.stageHeight; //Размер документа по y
			//width = doc_x;
			//height = doc_y;
			visible_map_x = doc_x - map_x;
			visible_map_y = doc_y - map_y - 50;
			map_rect.width = visible_map_x;
			map_rect.height = visible_map_y;
			if (kadr_ != null) {
				kadr_.width = width;
				kadr_.height = height;
			}
		}
		
		// происходит, когда меняется размер сцены
		function resize_main(ev:Event) {
			refreshSizes();
		}
		
		// переключаем кадр (отключаем предыдущий кадр, подключаем новый)
		static public function setKadr(ka:Sprite) {
			if (game_!=null) {
				if (kadr_!=null) {
					game_.removeChild(kadr_);
				}
				kadr_ = ka;
				game_.addChild(kadr_);
				//kadr_.x = 0;
				//kadr_.y = 0;
				//kadr_.width = game_.width;
				//kadr_.height = game_.height;
			}
		}
	}
}