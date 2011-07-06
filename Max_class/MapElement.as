package Max_class {
	
	public class MapElement {

		var type:String="green";
		var points:Array=new Array();
		
		public function MapElement(inType:String) {
			// constructor code
			type = inType;
		}
		
		public function addPoint(po:MapPoint) {
			points[points.length]=po;
		}

	}
	
}
