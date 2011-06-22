package  {
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.events.TextEvent;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	
	public class ATextField extends TextField {

		var atext:TextField;
		var parentObj;
		private var square:Sprite;
		private var lastValue:int;
		private var leftLabel:TextField;
		private var rightLabel:TextField;
		private var LAB_text:TextFormat;

		public function ATextField(inX,inY,obj,lefttext,righttext,fontSize:int=13) {
			lastValue = new int;
			lastValue = 0;
			x = inX+140;
			y = inY+2;
			text = "0";
			this.type = TextFieldType.INPUT;
			this.height = fontSize+7;
			this.width = 100;
			
			var INPUT_text:TextFormat = new TextFormat();
			INPUT_text.bold=true;
			INPUT_text.size=fontSize;
			INPUT_text.font="Tahoma";
			INPUT_text.color=0xeeeeee;
			INPUT_text.align=TextFormatAlign.RIGHT;
			
			LAB_text = new TextFormat();
			LAB_text.bold=true;
			LAB_text.size=fontSize;
			LAB_text.font="Tahoma";
			LAB_text.color=0x009900;
			LAB_text.align=TextFormatAlign.LEFT;
			
			leftLabel = new TextField;
			leftLabel.text = lefttext;
			leftLabel.setTextFormat(LAB_text);
			leftLabel.x = inX;
			leftLabel.y = inY;
			leftLabel.width = 150;
			
			rightLabel = new TextField;
			rightLabel.text = righttext;
			rightLabel.setTextFormat(LAB_text);
			rightLabel.x = inX+150+100;
			rightLabel.y = inY;
			rightLabel.width = 150;
			
			this.setTextFormat(INPUT_text);
			
			//addEventListener(TextEvent.TEXT_INPUT,ATextInput);
			addEventListener(FocusEvent.FOCUS_IN,AFocusIn);
			//addEventListener(KeyboardEvent.KEY_DOWN,AKeyDown);
			
			square = new Sprite();
			square.graphics.lineStyle(2,0x555555);
			square.graphics.beginFill(0x999999);
			square.graphics.drawRoundRectComplex( x+1, y+1, width-2, height-2, 3, 3, 3, 3);
			square.graphics.endFill();
			
			obj.addChild(square);
			obj.addChild(this);
			obj.addChild(leftLabel);
			obj.addChild(rightLabel);
			
			parentObj = obj;
		}
		
		public function removeMe() {
			parentObj.removeChild(leftLabel);
			parentObj.removeChild(rightLabel);
			parentObj.removeChild(square);
			parentObj.removeChild(this);
		}
		
		public function setTextColor(tcolor) {
			LAB_text.color = tcolor;
			leftLabel.setTextFormat(LAB_text);
			rightLabel.setTextFormat(LAB_text);
		}
		
		public function moveLeftLabel(deltaX) {
			leftLabel.x+=deltaX;
		}
		
		private function ATextInput(ev:TextEvent) {
			//if (!ev.cancelable) trace("NO CANCEL!!!");
			//text = text + "1";
			if ( ev.text!="0" && int(ev.text)==0 ) {
				//trace("dispatch");
				text=lastValue.toString();
				this.dispatchEvent(ev);
			}
			lastValue = int(text);
		}
		
		private function AKeyDown(ev:KeyboardEvent) {
			if ( ev.charCode < 48 || ev.charCode > 57 ) {
				trace(ev.keyCode);
				this.dispatchEvent(ev);
			}
		}
		
		private function AFocusIn(ev:FocusEvent) {
			this.setSelection(0, length);
			//trace("focusIn");
		}

	}
	
}
