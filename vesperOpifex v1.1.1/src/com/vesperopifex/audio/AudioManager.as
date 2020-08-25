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
	import com.vesperopifex.data.CacheObject;
	import com.vesperopifex.data.SoundCache;
	import com.vesperopifex.display.book.GraphicPage;
	import com.vesperopifex.display.GraphicComponentObject;
	import com.vesperopifex.events.PageManagerEvent;
	import com.vesperopifex.utils.controllers.PageEventControl;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	
	public class AudioManager extends SoundCache 
	{
		public static const XML_AUDIO_TYPE:String				= "audioEvent";
		public static const XML_AUDIO_TYPE_ATT:String			= "type";
		public static const XML_AUDIO_STREAM:String				= "stream";
		public static const XML_AUDIO_CONTEXT:String			= "context";
		public static const XML_AUDIO_START_TIME:String			= "startTime";
		public static const XML_AUDIO_LOOPS:String				= "loops";
		public static const XML_AUDIO_SOUND_TRANSFORM:String	= "soundTransform";
		public static const XML_AUDIO_VOLUME:String				= "volume";
		public static const XML_AUDIO_LEFT_TO_LEFT:String		= "leftToLeft";
		public static const XML_AUDIO_LEFT_TO_RIGHT:String		= "leftToRight";
		public static const XML_AUDIO_PANNING:String			= "panning";
		public static const XML_AUDIO_RIGHT_TO_LEFT:String		= "rightToLeft";
		public static const XML_AUDIO_RIGHT_TO_RIGHT:String		= "rightToRight";
		
		protected static var _eventList:Array					= new Array();
		
		/**
		 * AudioManager :: Constructor.
		 */
		public function AudioManager() 
		{
			
		}
		
		public static function checkPageAudioEvents(object:GraphicPage, data:XML):void 
		{
			var item:XML		= null;
			for each (item in data[PageEventControl.XML_EVENT_NODE]) 
				if (String(item.@[XML_AUDIO_TYPE_ATT]) == XML_AUDIO_TYPE) 
					checkPageAudioEvent(object, item);
			for each (item in data[XML_AUDIO_TYPE]) 
					checkPageAudioEvent(object, item);
			for each (item in data[PageEventControl.XML_DATA_NODE][PageEventControl.XML_EVENT_NODE]) 
				if (String(item.@[XML_AUDIO_TYPE_ATT]) == XML_AUDIO_TYPE) 
					checkPageAudioEvent(object, item);
			for each (item in data[PageEventControl.XML_DATA_NODE][XML_AUDIO_TYPE]) 
				checkPageAudioEvent(object, item);
			for each (item in data.content[PageEventControl.XML_EVENT_NODE]) 
				if (String(item.@[XML_AUDIO_TYPE_ATT]) == XML_AUDIO_TYPE) 
					checkPageAudioEvent(object, item);
			for each (item in data.content[XML_AUDIO_TYPE]) 
				checkPageAudioEvent(object, item);
			for each (item in data.content[PageEventControl.XML_DATA_NODE][PageEventControl.XML_EVENT_NODE]) 
				if (String(item.@[XML_AUDIO_TYPE_ATT]) == XML_AUDIO_TYPE) 
					checkPageAudioEvent(object, item);
			for each (item in data.content[PageEventControl.XML_DATA_NODE][XML_AUDIO_TYPE]) 
				checkPageAudioEvent(object, item);
		}
		
		protected static function checkPageAudioEvent(object:GraphicPage, data:XML):void 
		{
			var string:String	= null;
			var context:XML		= null;
			string		= object.path + AudioEventObject.DELIMINATOR + String(data.@[XML_AUDIO_STREAM]);
			if (Boolean(data.@[XML_AUDIO_CONTEXT].length())) 
			{
				string	+= AudioEventObject.DELIMINATOR + assignGraphicAudioEventHandler(object, String(data.@[XML_AUDIO_CONTEXT]));
				_eventList.push(new AudioEventObject(string, object, data, generateSoundTransform(data)));
			}
			for each (context in data[XML_AUDIO_CONTEXT]) 
			{
				string	+= AudioEventObject.DELIMINATOR + assignPageAudioEventHandler(object, String(context));
				_eventList.push(new AudioEventObject(string, object as DisplayObject, data, generateSoundTransform(data)));
			}
		}
		
		protected static function assignPageAudioEventHandler(object:GraphicPage, context:String):String 
		{
			var rtn:String	= null;
			switch (context) 
			{
				
				case PageManagerEvent.CLOSE:
					object.addEventListener(PageManagerEvent.CLOSE, pageAudioEventHandler);
					rtn	= PageManagerEvent.CLOSE;
					break;
					
				case "PageManagerEvent.CLOSE":
					object.addEventListener(PageManagerEvent.CLOSE, pageAudioEventHandler);
					rtn	= PageManagerEvent.CLOSE;
					break;
					
				case PageManagerEvent.CLOSE_ANIMATION:
					object.addEventListener(PageManagerEvent.CLOSE_ANIMATION, pageAudioEventHandler);
					rtn	= PageManagerEvent.CLOSE_ANIMATION;
					break;
					
				case "PageManagerEvent.CLOSE_ANIMATION":
					object.addEventListener(PageManagerEvent.CLOSE_ANIMATION, pageAudioEventHandler);
					rtn	= PageManagerEvent.CLOSE_ANIMATION;
					break;
					
				case PageManagerEvent.DELETE:
					object.addEventListener(PageManagerEvent.DELETE, pageAudioEventHandler);
					rtn	= PageManagerEvent.DELETE;
					break;
					
				case "PageManagerEvent.DELETE":
					object.addEventListener(PageManagerEvent.DELETE, pageAudioEventHandler);
					rtn	= PageManagerEvent.DELETE;
					break;
					
				case PageManagerEvent.OPEN:
					object.addEventListener(PageManagerEvent.OPEN, pageAudioEventHandler);
					rtn	= PageManagerEvent.OPEN;
					break;
					
				case "PageManagerEvent.OPEN":
					object.addEventListener(PageManagerEvent.OPEN, pageAudioEventHandler);
					rtn	= PageManagerEvent.OPEN;
					break;
					
				case PageManagerEvent.OPEN_ANIMATION:
					object.addEventListener(PageManagerEvent.OPEN_ANIMATION, pageAudioEventHandler);
					rtn	= PageManagerEvent.OPEN_ANIMATION;
					break;
					
				case "PageManagerEvent.OPEN_ANIMATION":
					object.addEventListener(PageManagerEvent.OPEN_ANIMATION, pageAudioEventHandler);
					rtn	= PageManagerEvent.OPEN_ANIMATION;
					break;
					
			}
			return rtn;
		}
		
		protected static function pageAudioEventHandler(event:Event):void 
		{
			var string:String					= null;
			var audioObject:AudioEventObject	= null;
			for each (audioObject in _eventList) 
			{
				if (audioObject.object == event.target) 
				{
					string	= audioObject.id.slice(audioObject.id.lastIndexOf(AudioEventObject.DELIMINATOR) + AudioEventObject.DELIMINATOR.length);
					if (string == event.type) playAudio(audioObject);
				}
			}
		}
		
		public static function checkGraphicAudioEvents(object:GraphicComponentObject):void 
		{
			var item:XML		= null;
			var context:XML		= null;
			var string:String	= null;
			for each (item in object.data[PageEventControl.XML_EVENT_NODE]) 
				if (String(item.@[XML_AUDIO_TYPE_ATT]) == XML_AUDIO_TYPE) 
					checkGraphicAudioEvent(object, item);
			for each (item in object.data[XML_AUDIO_TYPE]) 
				checkGraphicAudioEvent(object, item);
			for each (item in object.data[PageEventControl.XML_DATA_NODE][PageEventControl.XML_EVENT_NODE]) 
				if (String(item.@[XML_AUDIO_TYPE_ATT]) == XML_AUDIO_TYPE) 
					checkGraphicAudioEvent(object, item);
			for each (item in object.data[PageEventControl.XML_DATA_NODE][XML_AUDIO_TYPE]) 
				checkGraphicAudioEvent(object, item);
		}
		
		protected static function checkGraphicAudioEvent(object:GraphicComponentObject, data:XML):void 
		{
			var context:XML		= null;
			var string:String	= null;
			string		= String(object.data.@id) + AudioEventObject.DELIMINATOR + String(data.@[XML_AUDIO_STREAM]);
			if (Boolean(data.@[XML_AUDIO_CONTEXT].length())) 
			{
				string	+= AudioEventObject.DELIMINATOR + assignGraphicAudioEventHandler(object.graphic, String(data.@[XML_AUDIO_CONTEXT]));
				_eventList.push(new AudioEventObject(string, object.graphic, object.data, generateSoundTransform(data)));
			}
			for each (context in data[XML_AUDIO_CONTEXT]) 
			{
				string	+= AudioEventObject.DELIMINATOR + assignGraphicAudioEventHandler(object.graphic, String(context));
				_eventList.push(new AudioEventObject(string, object.graphic, object.data, generateSoundTransform(data)));
			}
		}
		
		protected static function assignGraphicAudioEventHandler(object:DisplayObject, context:String):String 
		{
			var rtn:String	= null;
			switch (context) 
			{
				
				case MouseEvent.CLICK:
					object.addEventListener(MouseEvent.CLICK, graphicAudioEventHandler);
					rtn	= MouseEvent.CLICK;
					break;
					
				case "MouseEvent.CLICK":
					object.addEventListener(MouseEvent.CLICK, graphicAudioEventHandler);
					rtn	= MouseEvent.CLICK;
					break;
					
				case MouseEvent.DOUBLE_CLICK:
					object.addEventListener(MouseEvent.DOUBLE_CLICK, graphicAudioEventHandler);
					rtn	= MouseEvent.DOUBLE_CLICK;
					break;
					
				case "MouseEvent.DOUBLE_CLICK":
					object.addEventListener(MouseEvent.DOUBLE_CLICK, graphicAudioEventHandler);
					rtn	= MouseEvent.DOUBLE_CLICK;
					break;
					
				case MouseEvent.MOUSE_DOWN:
					object.addEventListener(MouseEvent.MOUSE_DOWN, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_DOWN;
					break;
					
				case "MouseEvent.MOUSE_DOWN":
					object.addEventListener(MouseEvent.MOUSE_DOWN, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_DOWN;
					break;
					
				case MouseEvent.MOUSE_MOVE:
					object.addEventListener(MouseEvent.MOUSE_MOVE, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_MOVE;
					break;
					
				case "MouseEvent.MOUSE_MOVE":
					object.addEventListener(MouseEvent.MOUSE_MOVE, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_MOVE;
					break;
					
				case MouseEvent.MOUSE_OUT:
					object.addEventListener(MouseEvent.MOUSE_OUT, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_OUT;
					break;
					
				case "MouseEvent.MOUSE_OUT":
					object.addEventListener(MouseEvent.MOUSE_OUT, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_OUT;
					break;
					
				case MouseEvent.MOUSE_OVER:
					object.addEventListener(MouseEvent.MOUSE_OVER, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_OVER;
					break;
					
				case "MouseEvent.MOUSE_OVER":
					object.addEventListener(MouseEvent.MOUSE_OVER, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_OVER;
					break;
					
				case MouseEvent.MOUSE_UP:
					object.addEventListener(MouseEvent.MOUSE_UP, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_UP;
					break;
					
				case "MouseEvent.MOUSE_UP":
					object.addEventListener(MouseEvent.MOUSE_UP, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_UP;
					break;
					
				case MouseEvent.MOUSE_WHEEL:
					object.addEventListener(MouseEvent.MOUSE_WHEEL, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_WHEEL;
					break;
					
				case "MouseEvent.MOUSE_WHEEL":
					object.addEventListener(MouseEvent.MOUSE_WHEEL, graphicAudioEventHandler);
					rtn	= MouseEvent.MOUSE_WHEEL;
					break;
					
				case MouseEvent.ROLL_OUT:
					object.addEventListener(MouseEvent.ROLL_OUT, graphicAudioEventHandler);
					rtn	= MouseEvent.ROLL_OUT;
					break;
					
				case "MouseEvent.ROLL_OUT":
					object.addEventListener(MouseEvent.ROLL_OUT, graphicAudioEventHandler);
					rtn	= MouseEvent.ROLL_OUT;
					break;
					
				case MouseEvent.ROLL_OVER:
					object.addEventListener(MouseEvent.ROLL_OVER, graphicAudioEventHandler);
					rtn	= MouseEvent.ROLL_OVER;
					break;
					
				case "MouseEvent.ROLL_OVER":
					object.addEventListener(MouseEvent.ROLL_OVER, graphicAudioEventHandler);
					rtn	= MouseEvent.ROLL_OVER;
					break;
					
				case Event.ADDED:
					object.addEventListener(Event.ADDED, graphicAudioEventHandler);
					rtn	= Event.ADDED;
					break;
					
				case "Event.ADDED":
					object.addEventListener(Event.ADDED, graphicAudioEventHandler);
					rtn	= Event.ADDED;
					break;
					
				case Event.FULLSCREEN:
					object.addEventListener(Event.FULLSCREEN, graphicAudioEventHandler);
					rtn	= Event.FULLSCREEN;
					break;
					
				case "Event.FULLSCREEN":
					object.addEventListener(Event.FULLSCREEN, graphicAudioEventHandler);
					rtn	= Event.FULLSCREEN;
					break;
					
				case Event.REMOVED:
					object.addEventListener(Event.REMOVED, graphicAudioEventHandler);
					rtn	= Event.REMOVED;
					break;
					
				case "Event.REMOVED":
					object.addEventListener(Event.REMOVED, graphicAudioEventHandler);
					rtn	= Event.REMOVED;
					break;
					
				case Event.SCROLL:
					object.addEventListener(Event.SCROLL, graphicAudioEventHandler);
					rtn	= Event.SCROLL;
					break;
					
				case "Event.SCROLL":
					object.addEventListener(Event.SCROLL, graphicAudioEventHandler);
					rtn	= Event.SCROLL;
					break;
					
			}
			return rtn;
		}
		
		protected static function graphicAudioEventHandler(event:Event):void 
		{
			var string:String					= null;
			var audioObject:AudioEventObject	= null;
			for each (audioObject in _eventList) 
			{
				if (audioObject.object == event.target) 
				{
					string	= audioObject.id.slice(audioObject.id.lastIndexOf(AudioEventObject.DELIMINATOR) + AudioEventObject.DELIMINATOR.length);
					if (string == event.type) playAudio(audioObject);
				}
			}
		}
		
		protected static function playAudio(audioObject:AudioEventObject):void 
		{
			var array:Array				= audioObject.id.split(AudioEventObject.DELIMINATOR);
			var objectId:String			= String(array[0]);
			var audioId:String			= String(array[1]);
			var eventId:String			= String(array[2]);
			var audio:AudioLoader		= null;
			var cacheObj:CacheObject	= null;
			if (_dataArray.length) 
			{
				for each (cacheObj in _dataArray) 
					if (cacheObj.id == audioId) 
						audio = cacheObj.data as AudioLoader;
			}
			if (audio) 
				playAudioObject(audioObject, audio);
		}
		
		protected static function playAudioObject(audioObject:AudioEventObject, audioLoader:AudioLoader):void 
		{
			audioLoader.play(Number(audioObject.data.@[XML_AUDIO_START_TIME]), int(audioObject.data.@[XML_AUDIO_LOOPS]), audioObject.transform);
		}
		
		protected static function generateSoundTransform(data:XML):SoundTransform 
		{
			var item:XML			= null;
			var rtn:SoundTransform	= new SoundTransform();
			for each (item in data[XML_AUDIO_SOUND_TRANSFORM].@*) 
			{
				switch (String(item.name())) 
				{
					
					case XML_AUDIO_VOLUME:
						rtn.volume			= Number(item);
						break;
						
					case XML_AUDIO_LEFT_TO_LEFT:
						rtn.leftToLeft		= Number(item);
						break;
						
					case XML_AUDIO_LEFT_TO_RIGHT:
						rtn.leftToRight		= Number(item);
						break;
						
					case XML_AUDIO_PANNING:
						rtn.pan				= Number(item);
						break;
						
					case XML_AUDIO_RIGHT_TO_LEFT:
						rtn.rightToLeft		= Number(item);
						break;
						
					case XML_AUDIO_RIGHT_TO_RIGHT:
						rtn.rightToRight	= Number(item);
						break;
						
				}
			}
			return rtn;
		}
		
	}
	
}