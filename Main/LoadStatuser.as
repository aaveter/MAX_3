package Main {
	
	import flash.display.Sprite;
	
	public class LoadStatuser extends Sprite {
		
		private var minPos:int = 0;
		private var maxPos:int = 100;
		private var pos:int = 0;
		
		public function setPos(val:int) {
			pos = val;
			
			var dx:int = pos - minPos;
			var mdx:int = maxPos - minPos;
			
			graphics.beginFill(0x999999);
			graphics.drawRect(4, 4, (width-8)*dx/mdx, height-10);
			graphics.endFill();
		}
		
		public function getPos():int {
			return pos;
		}
		
		public function setMinPos(val:int) {
			minPos = val;
		}
		
		public function getMinPos():int {
			return minPos;
		}
		
		public function setMaxPos(val:int) {
			maxPos = val;
		}
		
		public function getMaxPos():int {
			return maxPos;
		}

		public function LoadStatuser(newX:int,newY:int,wid:int, hei:int) {
			// constructor code
			
			x = newX;
			y = newY;
			refreshMe(wid, hei);
		}
		
		public function refreshMe(wid:int, hei:int) {
			graphics.clear();
			graphics.lineStyle(2,0x999999);
			graphics.beginFill(0xcccccc);
			trace("x="+x.toString()+"y="+y.toString()+"w="+width.toString()+"h="+height.toString());
			graphics.drawRect(0,0,wid,hei);
			graphics.endFill();
		}

	}
	
}
