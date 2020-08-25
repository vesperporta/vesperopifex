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
package com.vesperopifex.audio 
{
	import flash.display.DisplayObject;
	import flash.media.SoundTransform;
	
	internal class AudioEventObject 
	{
		public static const DELIMINATOR:String	= "::";
		
		protected var _id:String				= null;
		protected var _object:DisplayObject		= null;
		protected var _data:XML					= null;
		protected var _transform:SoundTransform	= null;
		
		public function get id():String { return _id; }
		
		public function get object():DisplayObject { return _object; }
		
		public function get data():XML { return _data; }
		
		public function get transform():SoundTransform { return _transform; }
		
		/**
		 * AudioEventObject :: Constructor.
		 * 	A generic Object object to contain information regarding audio information.
		 * @param	id	<String>	the identifier of the audio application.
		 * @param	object	<DisplayObject>	the dispatcher of the event(s) to listen to.
		 * @param	data	<XML>	the event information to generate the dispatches from.
		 * @param	transform	<SoundTransform>	a generic audio modifier for the playback of any audio sounds.
		 */
		public function AudioEventObject(id:String, object:DisplayObject, data:XML, transform:SoundTransform) 
		{
			_id			= id;
			_object		= object;
			_data		= data;
			_transform	= transform;
		}
		
	}
	
}