package Max_class
{
	import flash.net.URLLoader;

	public class MaxMapLoader
	{
		public var cell:Array=new Array();
		public var map_size:Number;
		public function MaxMapLoader(map_load:URLLoader)
		{
			map_load.data.position = 0;
			map_size = map_load.data.readInt();
			//Считываем всю информацию по клеткам
			for (var gor = 0; gor<map_size; gor++)
			{
				cell[gor] = new Array  ;
				for (var vert = 0; vert<map_size; vert++)
				{
					cell[gor][vert] = new Array(
					"type",
					"optimize",
					"source_t",
					"source_n"
					);
					cell[gor][vert]["type"] = map_load.data.readUTF();
					cell[gor][vert]["optimize"] = 0;
				}
			}
		}
	}
}