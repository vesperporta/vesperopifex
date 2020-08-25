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
package com.vesperopifex.display.utils 
{
	import com.vesperopifex.events.PreloadVisualErrorEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class PreloadVisual extends Sprite implements IPreloadVisual 
	{
		public static const FRACTION_MAX:Number		= 1;
		public static const FRACTION_MIN:Number		= 0;
		public static const PERCENT_MAX:Number		= 100;
		public static const PERCENT_MIN:Number		= 0;
		
		[Embed(source='../../../../compiled-graphics.swf', symbol='PreloadingVisual')]
		public var PreloadingVisual:Class;
		
		protected var _fraction:Number				= 0;	// fraction of an integer (0 - 1)
		protected var _percent:uint					= 0;	// integer percentage (0 - 100)
		protected var _visual:MovieClip				= new PreloadingVisual();
		
		public function set fraction(value:Number):void 
		{
			if (value >= PERCENT_MIN && value <= FRACTION_MAX) 
			{
				_fraction	= value;
				_percent	= uint(Math.round(value * 100));
			} else dispatchEvent(new PreloadVisualErrorEvent(PreloadVisualErrorEvent.SCOPE, false, false, value));
			updateDisplay();
		}
		
		public function set percent(value:uint):void 
		{
			if (value >= PERCENT_MIN && value <= PERCENT_MAX) 
			{
				_percent	= value;
				_fraction	= value / 100;
			} else dispatchEvent(new PreloadVisualErrorEvent(PreloadVisualErrorEvent.SCOPE, false, false, value));
			updateDisplay();
		}
		
		/**
		 * Constructor.
		 */
		public function PreloadVisual() 
		{
			super();
			addChild(_visual);
			_visual.stop();
		}
		
		protected function updateDisplay():void 
		{
			_visual.gotoAndStop(Math.round(_visual.totalFrames * _fraction));
		}
		
	}
	
}