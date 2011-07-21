package Main
{
	import flash.display.Sprite;

	public class shadow extends Sprite
	{
		//st - цель, которую накрываем тенью
		public function shadow(st:Sprite)
		{
			graphics.beginFill(0x000000,0.5)
			graphics.drawRect(0,0,st.width/st.scaleX,st.height/st.scaleY)
			st.addChild(this)			
		}
	}
}