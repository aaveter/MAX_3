package Andrey {
	
	import MaxMain;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.display.Sprite;
	
	public class MaxPlayersChoose {

		var main:MaxMain;
		var buttons_press:Array;
		var buttons:Array;
		var button:int;
		var button_last:int;
		var number_text:Array;
		var allplayer:int;
		var players:Array;
		var player:int;
		var Player_text:TextField;
		var players_text:Array;
		var name_text:Array;
		var buttons_menu:MovieClip;
		var players_units:Array;//Массив всех юнитов, всех игроков
		var pu:int;//Номер юнита в массиве юнитов игрока
		var Ok_1=null;
		var units:Array;
		var unit:int;
			
		public function MaxPlayersChoose(main_) {
			// constructor code
			main = main_;
			units = new Array  ;
			unit = 0;
			players_units = new Array  ;//Массив всех юнитов, всех игроков
			pu = new int  ;//Номер юнита в массиве юнитов игрока
			//Рисуем первый кадр. Выбираем игроков и вводим их имена
			buttons_press=new Array  ;
			buttons=new Array  ;
			button=new int  ;
			button_last=0;
			number_text=new Array  ;
			allplayer=new int  ;
			players=new Array  ;
			player;
			Player_text = new TextField();
			players_text=new Array  ;
			name_text=new Array  ;
			buttons_menu=new MovieClip  ;
			
			main.addChild(Player_text);
			Player_text.border=true;
			Player_text.text="Выберите количество игроков";
			Player_text.setTextFormat(main.STATIC_text);
			Player_text.autoSize=TextFieldAutoSize.CENTER;
			Player_text.x = (main.doc_x - Player_text.width)/2;
			
			main.addChild(buttons_menu);
			buttons_menu.x=Player_text.x;
			buttons_menu.y=Player_text.y+Player_text.height+10;			
			
			create_button();
		}
		
		function create_button() {
			for (button = 2; button<=5; button++) {
				buttons[button]=new Button_class  ;
				buttons_menu.addChild(buttons[button]);
				buttons[button].x=(buttons[button].width + 10)*(button-2);
		
				number_text[button]=new TextField  ;
				buttons[button].addChild(number_text[button]);
				number_text[button].text=String(button);
				number_text[button].setTextFormat(main.Black_text);
				number_text[button].width=50;
				number_text[button].height=50;
		
				buttons_press[button]=new Button_press_class  ;
				buttons[button].addChild(buttons_press[button]);
		
				buttons_press[button].addEventListener(MouseEvent.CLICK, choose_button);
				buttons_press[button].buttonMode=true;
				function choose_button(event:MouseEvent) {
					var button_f:int=1;
					while (buttons_press[button_f] != event.target) {
						button_f+=1;
					}
					if (button_last!=0) {
						buttons[button_last].gotoAndStop(1);
						for (player = 1; player<button_last+1; player++) {
							main.removeChild(players_text[player]);
							main.removeChild(name_text[player]);
						}
					}
					buttons[button_f].gotoAndStop(2);
					button_last=button_f;
					allplayer=button_f;
					players.length=allplayer+1;
					create_player();
					//Создаем игроков и их свойства
					function create_player() {
						for (player = 1; player<players.length; player++) {
							players[player] = new Array(
							"name"
							);
							players_units[player]=new Array  ;
							players_text[player]=new TextField  ;
							main.addChild(players_text[player]);
							players_text[player].border=true;
							players_text[player].text=String("имя игрока "+player);
							players_text[player].setTextFormat(main.STATIC_text);
							players_text[player].autoSize=TextFieldAutoSize.LEFT;
							players_text[player].x=Player_text.x;
							players_text[player].y=buttons_menu.y+buttons_menu.height+30+(players_text[player].height+10)*(player-1);
		
							name_text[player]=new TextField  ;
							main.addChild(name_text[player]);
							name_text[player].border=true;
							name_text[player].text=String("игрок "+player);
							name_text[player].setTextFormat(main.INPUT_text);
							name_text[player].type=TextFieldType.INPUT;
							name_text[player].width=Player_text.width-players_text[player].width;
							name_text[player].height=players_text[player].height;
							name_text[player].x=Player_text.x+players_text[player].width;
							name_text[player].y=buttons_menu.y+buttons_menu.height+30+(name_text[player].height+10)*(player-1);
						}
						if (Ok_1==null) {
							Ok_1=new Ok_class  ;
							main.addChild(Ok_1);
							Ok_1.addEventListener(MouseEvent.CLICK, press_Ok_1);
						}
						Ok_1.x=(main.doc_x-Ok_1.width)/2;
						Ok_1.y=buttons_menu.y+buttons_menu.height+30+(players_text[players.length-1].height+10)*(players.length-1)+50;
						//doc_y-Ok_1.height-100;
						function press_Ok_1(event:MouseEvent) {
							for (player = 1; player<players.length; player++) {
								players[player]["name"]=name_text[player].text;
							}
							//Удаляю предидущий кадр
							while (main.numChildren() != 0) {
								main.removeChildAt(main.numChildren()-1);
							}
							//gotoAndStop(2);
							main.next();
						}
					}
					//Конец создания игроков
				}
			}
			buttons_menu.x = Player_text.x + (Player_text.width - buttons_menu.width)/2;
		}
		
		function create_player_unit() {
			pu=players_units[player].length;	
			players_units[player][pu]=new Array(
			  "bmp", //Картинка как выглядит юнит
			  "name",
			  "hits",
			  "armor",
			  "speed",
			  "power", //Мощность выстрела
			  "shots", //Количество выстрелов за ход
			  "type_move", //Вид передвижения юнита 1 - по земле, 2 - по воздуху, 3 - по воде, 
			  //4 - под водой, 5 - по горам
			  "type_attack", //Тип атаки юнита.1 - по наземным, 2 - по воздушным, 3 - по водным,
			  //4 - по подводным, 0 - нипокому
			  "ammo", //Количество патронов
			  "cost", //Стоимость постройки в ресурсах, отсюда же стимость покупки береться и длительность строительства.
			  "range",
			  "scan",
			  "build",
			  
			  //Параметры для текущих расчетов
			  "hits_now",
			  "speed_now",
			  "shots_now",
			  "ammo_now",
			  "point"
			  );	
			players_units[player][pu]["bmp"]=new units[unit]["bmp"];
			players_units[player][pu]["name"]=units[unit]["name"]
			players_units[player][pu]["hits"]=units[unit]["hits"]
			players_units[player][pu]["armor"]=units[unit]["armor"]
			players_units[player][pu]["speed"]=units[unit]["speed"]
			players_units[player][pu]["power"]=units[unit]["power"]
			players_units[player][pu]["shots"]=units[unit]["shots"]
			players_units[player][pu]["type_move"]=units[unit]["type_move"]
			players_units[player][pu]["type_attack"]=units[unit]["type_attack"]
			players_units[player][pu]["ammo"]=units[unit]["ammo"]
			players_units[player][pu]["cost"]=units[unit]["cost"]
			players_units[player][pu]["range"]=units[unit]["range"]
			players_units[player][pu]["scan"]=units[unit]["scan"]
			players_units[player][pu]["build"]=units[unit]["build"]
			players_units[player][pu]["hits_now"]=units[unit]["hits"]
			players_units[player][pu]["speed_now"]=units[unit]["speed"]
			players_units[player][pu]["shots_now"]=units[unit]["shots"]
			players_units[player][pu]["ammo_now"]=units[unit]["ammo"]
		}
		
/*function create_unit() {
	unit+=1;
	units[unit]=new Array(
	  "bmp", //Картинка как выглядит юнит
	  "name",
	  "hits",
	  "armor",
	  "speed",
	  "power", //Мощность выстрела
	  "shots", //Количество выстрелов за ход	
	  "type_move", //Вид передвижения юнита 1 - по земле, 2 - по воздуху, 3 - по воде, 
	  //4 - под водой, 5 - по горам
	  "type_attack", //Тип атаки юнита.1 - по наземным, 2 - по воздушным, 3 - по водным,
	  //4 - по подводным, 0 - нипокому	
	  "ammo", //Количество патронов
	  "cost", //Стоимость постройки в ресурсах, отсюда же стимость покупки береться и длительность строительства.
	  "range",
	  "scan",
	  "build" //Параметр показывает строит ли юнит здания.
	  );
}

create_unit();
units[unit]["bmp"]=ingener_class;
units[unit]["name"]="ingener";
units[unit]["hits"]=18;
units[unit]["armor"]=4;
units[unit]["speed"]=6;
units[unit]["power"]=0;
units[unit]["shots"]=0;
units[unit]["type_move"]="14";
units[unit]["type_attack"]="0";
units[unit]["ammo"]=0;
units[unit]["cost"]=18;
units[unit]["range"]=0;
units[unit]["scan"]=4;
units[unit]["build"]="true"

create_unit();
units[unit]["bmp"]=constructor_class;
units[unit]["name"]="constructor";
units[unit]["hits"]=24;
units[unit]["armor"]=8;
units[unit]["speed"]=6;
units[unit]["power"]=0;
units[unit]["shots"]=0;
units[unit]["type_move"]="14";
units[unit]["type_attack"]="0";
units[unit]["ammo"]=0;
units[unit]["cost"]=24;
units[unit]["range"]=0;
units[unit]["scan"]=4;
units[unit]["build"]="true"

create_unit();
units[unit]["bmp"]=scout_class
units[unit]["name"]="scout";
units[unit]["hits"]=12;
units[unit]["armor"]=4;
units[unit]["speed"]=9;
units[unit]["power"]=8;
units[unit]["shots"]=1;
units[unit]["type_move"]="1";
units[unit]["type_attack"]="1";
units[unit]["ammo"]=8;
units[unit]["cost"]=12;
units[unit]["range"]=3;
units[unit]["scan"]=9;
units[unit]["build"]="false"*/

	}
	
}




//Конец рисование первого кадра