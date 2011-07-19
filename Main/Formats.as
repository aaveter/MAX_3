package Main
{
	import flash.text.*;

	public class Formats
	{
		public static var Static:TextFormat= new TextFormat();
		public static var Input:TextFormat= new TextFormat();
		public static var Title:TextFormat= new TextFormat();
		public static var Normal:TextFormat= new TextFormat();
		
		Static.bold = true;
		Static.size = 18;
		Static.font = "Tahoma";
		Static.color = 0x000099;
		Static.align = TextFormatAlign.CENTER;
		
		Input.bold = true;
		Input.size = 18;
		Input.font = "Tahoma";
		Input.color = 0x000099;
		Input.align = TextFormatAlign.LEFT;

		Title.bold = true;
		Title.size = 40;
		Title.font = "Tahoma";
		Title.color = 0x000000;
		Title.align = TextFormatAlign.CENTER;

		Normal.bold = true;
		Normal.size = 14;
		Normal.font = "Tahoma";
		Normal.color = 0x000000;
		Normal.align = TextFormatAlign.CENTER;		
		
		public function Formats()
		{
		}
	}
}