package Main
{
	import flash.text.*;
	import flash.display.*;
	import flash.events.MouseEvent;
	import Main.Color_box;

	public class Panel_txt extends Sprite
	{
		public var all_txt:Array=new Array();//массив текстов
		public var all_bc:Array=new Array();//массив блоков для выбора цвета игрока

		public function Panel_txt(colors:Array,max_txt:Number=2,content:String="",l:int=200,lcb:int=20)
		{
			var dist:Number = 10;//Расстояние между текстами
			for (var cur_txt = 0; cur_txt<max_txt; cur_txt++)
			{
				var n:Number = cur_txt + 1;
				all_txt[cur_txt] = new TextField()  ;
				all_txt[cur_txt].text = content + " " + n;
				all_txt[cur_txt].border = true;
				all_txt[cur_txt].height = all_txt[cur_txt].textHeight + 15;
				all_txt[cur_txt].width = l * 3 / 5;
				all_txt[cur_txt].setTextFormat(Formats.Input);
				all_txt[cur_txt].type = TextFieldType.INPUT;
				all_txt[cur_txt].y = (all_txt[cur_txt].height+dist)*(cur_txt-1);

				all_bc[cur_txt] = new Color_box(colors[cur_txt],l / 5,all_txt[cur_txt].height,colors,lcb);
				all_bc[cur_txt].x = l * 4 / 5;
				all_bc[cur_txt].y=(all_txt[cur_txt].height+dist)*(cur_txt-1);

				this.addChild(all_txt[cur_txt]);
				this.addChild(all_bc[cur_txt]);

				//Функция по замене цвета, чтобы цвета игроков не совпадали;
				all_bc[cur_txt].addEventListener(MouseEvent.CLICK,cl);
				function cl(ev:MouseEvent)
				{
					//Перебираем все боксы для цветов
					for (var cur_txt = 0; cur_txt<max_txt; cur_txt++)
					{
						//Находим совпадения
						if (all_bc[cur_txt].color == ev.currentTarget.color && all_bc[cur_txt] != ev.currentTarget)
						{
							//Перебираем возможные цвета
							for (var i:int = 0; i<colors.length; i++)
							{
								//Для каждого цвета перебираем цвета боксов
								var er:Number = 0;
								for (var p:int = 0; p<all_bc.length; p++)
								{
									//Определяем что цвет не подходит
									if (colors[i] == all_bc[p].color)
									{
										er = 1;
										break;
									}
								}
								//Спрашиваем подходит ли цвет и если да - 0, то меняем, а перебор останавливаем
								if (er == 0)
								{
									removeChild(all_bc[cur_txt]);
									all_bc[cur_txt] = new Color_box(colors[i],l / 5,all_txt[cur_txt].height,colors,lcb);
									all_bc[cur_txt].x = l * 4 / 5;
									all_bc[cur_txt].y=(all_txt[cur_txt].height+dist)*(cur_txt-1);
									addChild(all_bc[cur_txt]);
									all_bc[cur_txt].addEventListener(MouseEvent.CLICK,cl);
									break;
								}
							}
						}
					}
				}
			}
		}
	}
}