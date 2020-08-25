/**
 * @author:		Laurence Green
 * @email:		contact@laurencegreen.com
 * @www:		http://www.laurencegreen.com/
 * @code:		http://vesper-opifex.googlecode.com/
 * @blog:		http://vesperopifex.blogspot.com/
 * 
The MIT License

Copyright (c) 2008-2009 Laurence Green

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */
package com.vesperopifex.display.ui 
{
	import flash.display.Sprite;
	
	public class SimpleProgressBar extends Sprite 
	{
		protected var _alpha:Number		= 1;
		protected var _color:uint		= 0x00;
		protected var _height:Number	= 10;
		protected var _progress:Number	= 0;
		protected var _sprite:Sprite	= null;
		protected var _width:Number		= 150;
		
		public override function set width(value:Number):void 
		{
			_width = value;
			update();
		}
		
		public override function set height(value:Number):void 
		{
			_height = value;
		}
		
		public function set progress(value:Number):void 
		{
			if (_progress < 0 || _progress > 1) 
			{
				throw new ArgumentError("The value passed is outside the required range 0 - 1");
				return;
			}
			_progress = value;
			update();
		}
		
		public override function set alpha(value:Number):void 
		{
			_alpha = value;
			redraw();
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
			redraw();
		}
		
		public function SimpleProgressBar() 
		{
			redraw();
		}
		
		protected function redraw():void 
		{
			if (_sprite) removeChild(_sprite);
			_sprite = new Sprite();
			_sprite.graphics.beginFill(_color, _alpha);
			_sprite.graphics.drawRect(0, 0, _width, _height);
			addChild(_sprite);
			update();
		}
		
		protected function update():void 
		{
			_sprite.scaleX = _progress;
		}
		
	}
	
}