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
package com.vesperopifex.display.video 
{
	import com.vesperopifex.events.NetStreamClientEvent;
	import com.vesperopifex.utils.Settings;
	import flash.events.EventDispatcher;
	
	public class NetStreamClient extends EventDispatcher 
	{
		public static const META_DATA_DURATION:String	= "duration";
		public static const META_DATA_HEIGHT:String		= "height";
		public static const META_DATA_WIDTH:String		= "width";
		
		public function NetStreamClient() 
		{
			
		}
		
		/**
		 * onMetaData :: Called somewhere after .play() is called and before the playhead advances
		 * @param	info	<Object>
		 */
		public function onMetaData (info:Object):void 
		{
			trace(Settings.FRAMEWORK + "VIDEO-METADATA\t::\tduration=" + info.duration + "\twidth=" + info.width + "\theight=" + info.height + " framerate=" + info.framerate);
			dispatchEvent(new NetStreamClientEvent(NetStreamClientEvent.META_DATA, true, true, info));
		}

		/**
		 * onCuePoint :: Called when a cuePoint is reached
		 * @param	info	<Object>
		 */
		public function onCuePoint (info:Object):void 
		{
			trace(Settings.FRAMEWORK + "VIDEO-CUEPOINT\t::\ttime=" + info.time + "\tname=" + info.name + "\ttype=" + info.type);
			dispatchEvent(new NetStreamClientEvent(NetStreamClientEvent.CUE_POINT_DATA, true, true, info));
		}

	}
	
}