package Max_class {
	
	import Main.*;
	import flash.display.Sprite;
	
	public class KadrFon extends Sprite {

		public function KadrFon( wid:int, hei:int ) {
			// constructor code
			
			var size:int = 0;
			if (wid > hei) size = wid;
			else hei = wid;
			
			graphics.beginFill(0x999999);
			graphics.drawRect(0, 0, size, size);
			graphics.endFill();
			
			for ( var i:int = 0; i < size*2; i+=60 ) {
				graphics.beginFill(0xcccccc);
				graphics.moveTo(i, 0);
				graphics.lineTo(i+30, 0);
				graphics.lineTo(0, i+30);
				graphics.lineTo(0, i);
				graphics.lineTo(i, 0);
				graphics.endFill();
			}
		}

	}
	
}
