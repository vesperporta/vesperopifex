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
	import com.vesperopifex.display.GraphicComponentObject;
	import com.vesperopifex.display.GraphicFactory;
	import com.vesperopifex.display.IDataObject;
	import com.vesperopifex.display.IXMLDataObject;
	import com.vesperopifex.display.ui.video.IVideoControlPanel;
	import com.vesperopifex.display.ui.video.SimpleVideoControlPanel;
	import com.vesperopifex.events.DataEvent;
	import com.vesperopifex.events.NetStreamClientEvent;
	import com.vesperopifex.events.PageManagerEvent;
	import com.vesperopifex.utils.controllers.PageEventControl;
	import com.vesperopifex.utils.MinimumPlayerVersion;
	import com.vesperopifex.utils.PlayerVersionObject;
	import com.vesperopifex.utils.XMLGraphicDisplay;
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.media.SoundTransform;
	
	public class VideoLoader extends VideoPlayback implements IXMLDataObject, IDataObject, IVideoControl, IVideoControlPanel 
	{
		public static const FILE_TYPE:Object = 
		{
			flv: new PlayerVersionObject("flv", MinimumPlayerVersion.ON2_VP6_PLAYBACK),
			mp4: new PlayerVersionObject("mp4", MinimumPlayerVersion.H264_PLAYBACK), 
			f4v: new PlayerVersionObject("f4v", MinimumPlayerVersion.H264_PLAYBACK), 
			m4a: new PlayerVersionObject("m4a", MinimumPlayerVersion.H264_PLAYBACK), 
			mov: new PlayerVersionObject("mov", MinimumPlayerVersion.H264_PLAYBACK), 
			mp4v: new PlayerVersionObject("mp4v", MinimumPlayerVersion.H264_PLAYBACK), 
			_3gp: new PlayerVersionObject("3gp", MinimumPlayerVersion.H264_PLAYBACK), 
			_3g2: new PlayerVersionObject("3g2", MinimumPlayerVersion.H264_PLAYBACK)
		};
		
		protected static const GRAPHIC_FACTORY:GraphicFactory	= new GraphicFactory();
		
		protected var _listenTo:IEventDispatcher				= null;
		protected var _dataUpdate:Object						= null;
		protected var _eventData:XMLList						= null;
		protected var _XMLData:XML								= null;
		protected var _active:Boolean							= false;
		protected var _controller:PageEventControl				= null;
		protected var _videoPlayer:IVideoControl				= null;
		protected var _mute:Boolean								= false;
		protected var _mutedVolume:Number						= -1;
		protected var _duration:Number							= -1;
		protected var _videoHeight:Number						= NaN;
		protected var _videoWidth:Number						= NaN;
		
		public function get listenTo():IEventDispatcher { return _listenTo; }
		public function set listenTo(value:IEventDispatcher):void 
		{
			if (_listenTo) removeListener();
			_listenTo	= value;
			assignListener();
		}
		
		public function get dataUpdate():Object { return _dataUpdate; }
		public function set dataUpdate(value:Object):void 
		{
			_dataUpdate	= value;
		}
		
		public function get videoPlayer():IVideoControl { return this as IVideoControl; }
		public function set videoPlayer(value:IVideoControl):void 
		{
			throw new ArgumentError("Can not assign an IVideoPlayer to a VideoLoader");
		}
		
		public function get eventData():XMLList { return _eventData; }
		
		public function get XMLData():XML { return _XMLData; }
		public function set XMLData(value:XML):void 
		{
			_XMLData	= value;
			dataPasser();
		}
		
		public function get active():Boolean { return _active; }
		public function set active(value:Boolean):void 
		{
			_active		= value;
		}
		
		public function get controller():PageEventControl { return _controller; }
		public function set controller(value:PageEventControl):void 
		{
			_controller	= value;
		}
		
		public function get mute():Boolean { return _mute }
		public function set mute(value:Boolean):void 
		{
			if (value) 
			{
				_mutedVolume	= volume;
				volume			= 0;
			} else 
			{
				if (_mutedVolume != -1) 
					volume		= _mutedVolume;
			}
		}
		
		public function get volume():Number { return _stream.soundTransform.volume; }
		public function set volume(value:Number):void 
		{
			_stream.soundTransform	= new SoundTransform(value, _stream.soundTransform.pan);
		}
		
		public function get videoHeight():Number { return _videoHeight; }
		public function set videoHeight(value:Number):void 
		{
			_videoHeight	= value;
			_video.height	= _videoHeight;
		}
		
		public function get videoWidth():Number { return _videoWidth; }
		public function set videoWidth(value:Number):void 
		{
			_videoWidth		= value;
			_video.width	= _videoWidth;
		}
		
		public function get duration():Number { return _duration; }
		
		public function get available():Boolean { return Boolean(_stream); }
		
		/**
		 * VideoLoader :: Constructor.
		 */
		public function VideoLoader(server:String = null) 
		{
			super(server);
		}
		
		/**
		 * pause :: pause the current Net_stream
		 */
		public override function pause():void 
		{
			super.pause();
		}
		
		/**
		 * resume :: used after the pause method has been called to resume play of the stream.
		 */
		public override function resume():void 
		{
			super.resume();
		}
		
		/**
		 * seek :: seek to a position of the streaming video if it is not live content.
		 * @param	value	<Number>
		 */
		public override function seek(value:Number):void 
		{
			super.seek(value);
		}
		
		/**
		 * togglePause :: toggle between the paused states of the connected stream.
		 */
		public override function togglePause():void 
		{
			super.togglePause();
		}
		
		/**
		 * dataPasser :: data assigned to this object is passed here for actioning.
		 */
		protected function dataPasser():void
		{
			if (Boolean(_XMLData[SimpleVideoControlPanel.XML_VIDEO_CONTROL].length())) 
			{
				var item:XML						= null;
				var controlPanel:IVideoControlPanel	= null;
				var type:String						= null;
				if (_XMLData[SimpleVideoControlPanel.XML_VIDEO_CONTROL].@type.length()) 
					type							= String(_XMLData[SimpleVideoControlPanel.XML_VIDEO_CONTROL].@type);
				else if (_XMLData[SimpleVideoControlPanel.XML_VIDEO_CONTROL].type.length())
					type							= String(_XMLData[SimpleVideoControlPanel.XML_VIDEO_CONTROL].type);
				if (type == SimpleVideoControlPanel.XML_VIDEO_TYPE) 
				{
					for each (item in _XMLData[SimpleVideoControlPanel.XML_VIDEO_CONTROL]) 
					{
						controlPanel				= new SimpleVideoControlPanel();
						controlPanel.videoPlayer	= videoPlayer;
						XMLGraphicDisplay.applyGraphicDetails(new GraphicComponentObject(controlPanel as DisplayObject, 0, item));
						if (controlPanel is DisplayObject) addChild(controlPanel as DisplayObject);
					}
					removeListener();
				} else 
				{
					if (_XMLData[SimpleVideoControlPanel.XML_VIDEO_CONTROL][GraphicFactory.XML_GRAPHIC].length())
					{
						var array:Array				= XMLGraphicDisplay.createGraphics(_XMLData[SimpleVideoControlPanel.XML_VIDEO_CONTROL]);
						for each (var obj:GraphicComponentObject in array) 
						{
							if (obj.graphic is IVideoControlPanel) 
							{
								controlPanel				= obj.graphic as IVideoControlPanel;
								controlPanel.videoPlayer	= videoPlayer;
								XMLGraphicDisplay.applyGraphicDetails(new GraphicComponentObject(controlPanel as DisplayObject, 0, item));
								if (controlPanel is DisplayObject) addChild(controlPanel as DisplayObject);
							}
						}
						removeListener();
					}
				}
			}
		}
		
		/**
		 * metaDataHandler :: handle the event captured from the NetStream client.
		 * @param	event	<NetStreamClientEvent>	the event dispatched from the client.
		 */
		protected override function metaDataHandler(event:NetStreamClientEvent):void 
		{
			super.metaDataHandler(event);
			for (var string:String in event.info) 
			{
				switch (string) 
				{
					
					case NetStreamClient.META_DATA_DURATION:
						_duration = Number(event.info[string]);
						break;
						
					case NetStreamClient.META_DATA_HEIGHT:
						if (!_videoHeight) videoHeight	= Number(event.info[string]);
						break;
						
					case NetStreamClient.META_DATA_WIDTH:
						if (!_videoWidth) videoWidth	= Number(event.info[string]);
						break;
						
				}
			}
			_dataUpdate = event.info;
			dispatchDataEvent(event.info);
		}
		
		/**
		 * cuePointDataHandler :: handle the event captured from the NetStream client.
		 * @param	event	<NetStreamClientEvent>	the event dispatched from the client.
		 */
		protected override function cuePointDataHandler(event:NetStreamClientEvent):void 
		{
			super.cuePointDataHandler(event);
			_dataUpdate = event.info;
			dispatchDataEvent(event.info);
		}
		
		/**
		 * dispatchDataEvent :: dispatch a DataEvent into the event stream passing the data via the event dispatched.
		 * @param	data	<Object>	any data form required to be passed.
		 */
		protected function dispatchDataEvent(data:Object):void 
		{
			dispatchEvent(new DataEvent(DataEvent.DATA_UPDATE, true, false, data));
		}
		
		/**
		 * pageOpenHandler :: Event listener upon the opening of the listened page.
		 * @param	event	<PageManagerEvent>	Event dispatched from the particular page upon opening.
		 */
		protected function pageOpenHandler(event:PageManagerEvent):void 
		{
			seek(0);
			resume();
		}
		
		/**
		 * pageCloseHandler :: Event listener upon the closing of the listened page.
		 * @param	event	<PageManagerEvent>	Event dispatched from the particular page upon closing.
		 */
		protected function pageCloseHandler(event:PageManagerEvent):void 
		{
			pause();
		}
		
		/**
		 * assignListener :: Add event listeners to the available page.
		 */
		protected function assignListener():void 
		{
			_listenTo.addEventListener(PageManagerEvent.CLOSE, pageCloseHandler);
			_listenTo.addEventListener(PageManagerEvent.OPEN, pageOpenHandler);
		}
		
		/**
		 * removeListener :: remove the current event listeners from the available page.
		 */
		protected function removeListener():void 
		{
			_listenTo.removeEventListener(PageManagerEvent.CLOSE, pageCloseHandler);
			_listenTo.removeEventListener(PageManagerEvent.OPEN, pageOpenHandler);
		}
		
	}
	
}