package Max_class
{	
	import flash.net.*
	import flash.events.Event;
	import flash.display.Sprite;
	import Main.Game;

	public class kadr_2 extends Sprite
	{
		public function kadr_2()
		{
			var urlRequestMap:URLRequest = new URLRequest("map3.txt");
			var urlLoaderMap:URLLoader=new URLLoader();
			urlLoaderMap.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoaderMap.load(urlRequestMap);
			urlLoaderMap.addEventListener(Event.COMPLETE, maps_complete);
			function maps_complete(ev:Event)
			{
				var k3:kadr_3=new kadr_3(urlLoaderMap)
				//addChild(k3)
				Game.setKadr(k3);
			}
		}
	}
}