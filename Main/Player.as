package Main
{
	import flash.geom.Point;

	public class Player
	{
		public var name:String
		public var color:uint
		public var sl:Point=new Point(0,0)
		public var units:Array=new Array()
		public function Player(n:String,c:uint)
		{
			name=n
			color=c
		}
	}
}