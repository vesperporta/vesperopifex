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
package com.vesperopifex.display.ui.video 
{
	import com.vesperopifex.display.GraphicComponentObject;
	import com.vesperopifex.display.GraphicFactory;
	import com.vesperopifex.display.IXMLDataObject;
	import com.vesperopifex.display.ui.SimpleTable;
	import com.vesperopifex.display.ui.state.AudioControlButtonState;
	import com.vesperopifex.display.ui.state.IStateDisplayObject;
	import com.vesperopifex.display.ui.state.SimpleStateDisplayObject;
	import com.vesperopifex.display.ui.state.VideoControlButtonState;
	import com.vesperopifex.display.ui.state.XMLControlButtonState;
	import com.vesperopifex.display.video.IVideoControl;
	import com.vesperopifex.events.PageManagerEvent;
	import com.vesperopifex.utils.XMLGraphicDisplay;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	public class SimpleVideoControlPanel extends SimpleTable implements IVideoControlPanel 
	{
		public static const XML_VIDEO_CONTROL:String				= "videocontrolpanel";
		public static const XML_VIDEO_TYPE:String					= "simple-video-control-panel";
		public static const XML_PLAY_PAUSE_BUTTON_ID:String			= "play-pause-button";
		public static const XML_MUTED_AUDIBLE_BUTTON_ID:String		= "muted-audible-button";
		public static const XML_RECORDING_STOPPED_BUTTON_ID:String	= "recording-stopped-button";
		public static const XML_APPENDING_STOPPED_BUTTON_ID:String	= "appending-stopped-button";
		public static const XML_SEEKING_BUFFER_BAR_ID:String		= "seeking-buffer-bar";
		public static const XML_VOLUME_BAR_ID:String				= "volume-bar";
		
		protected var _videoPlayer:IVideoControl					= null;
		protected var _dispatcher:IEventDispatcher					= null;
		protected var _playingPausedButton:IStateDisplayObject		= null;
		protected var _mutedAudibleButton:IStateDisplayObject		= null;
		protected var _recordingStoppedButton:IStateDisplayObject	= null;
		protected var _rewindButton:DisplayObject					= null;
		protected var _fastRewindButton:DisplayObject				= null;
		protected var _forwardButton:DisplayObject					= null;
		protected var _fastForwardButton:DisplayObject				= null;
		
		public function get videoPlayer():IVideoControl { return _videoPlayer; }
		public function set videoPlayer(value:IVideoControl):void 
		{
			_videoPlayer = value;
			_dispatcher = _videoPlayer.listenTo;
			assignListener();
		}
		
		/**
		 * SimpleVideoControlPanel :: Constructor.
		 */
		public function SimpleVideoControlPanel() 
		{
			super();
		}
		
		/**
		 * generateGraphics :: create the graphics for this control panel, dependant on the correct usage and formating of XML.
		 */
		protected override function generateGraphics():void
		{
			super.generateGraphics();
			var object:GraphicComponentObject	= null;
			for each (object in _children) 
			{
				switch (String(object.data.@id)) 
				{
					
					case XML_PLAY_PAUSE_BUTTON_ID:
						_playingPausedButton	= object.graphic as IStateDisplayObject;
						break;
						
					case XML_MUTED_AUDIBLE_BUTTON_ID:
						_mutedAudibleButton		= object.graphic as IStateDisplayObject;
						break;
						
					case XML_RECORDING_STOPPED_BUTTON_ID:
						_recordingStoppedButton	= object.graphic as IStateDisplayObject;
						break;
						
					case XML_APPENDING_STOPPED_BUTTON_ID:
						_recordingStoppedButton	= object.graphic as IStateDisplayObject;
						break;
						
					case VideoControlButtonState.FAST_FORWARD:
						_fastForwardButton		= object.graphic as DisplayObject;
						break;
						
					case VideoControlButtonState.FAST_REWIND:
						_fastRewindButton		= object.graphic as DisplayObject;
						break;
						
					case VideoControlButtonState.FORWARD:
						_forwardButton			= object.graphic as DisplayObject;
						break;
						
					case VideoControlButtonState.REWIND:
						_rewindButton			= object.graphic as DisplayObject;
						break;
						
				}
				object.graphic.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			}
		}
		
		/**
		 * buttonClickHandler :: evoked upon the clicking of any button instanced on this control panel.
		 * @param	event	<MouseEvent>	the event dispatched upon MouseEvent.MOUSE_DOWN and MouseEvent.MOUSE_UP events are captured.
		 */
		protected function buttonClickHandler(event:MouseEvent):void 
		{
			if (!_videoPlayer.available) return;
			if (event.currentTarget is SimpleStateDisplayObject) 
			{
				var target:SimpleStateDisplayObject = event.currentTarget as SimpleStateDisplayObject;
				if (target) 
				{
					switch (target.state) 
					{
						
						case VideoControlButtonState.PAUSED:
							target.state = VideoControlButtonState.PLAYING;
							if (_videoPlayer) _videoPlayer.togglePause();
							break;
							
						case VideoControlButtonState.PLAYING:
							target.state = VideoControlButtonState.PAUSED;
							if (_videoPlayer) _videoPlayer.togglePause();
							break;
							
						case VideoControlButtonState.APPENDING:
							target.state = VideoControlButtonState.STOPPED;
							break;
							
						case VideoControlButtonState.RECORDING:
							target.state = VideoControlButtonState.STOPPED;
							break;
							
						case VideoControlButtonState.SEEKING:
							break;
							
						case VideoControlButtonState.STOPPED:
							target.state = VideoControlButtonState.RECORDING;
							break;
							
						case AudioControlButtonState.MUTED:
							target.state = AudioControlButtonState.AUDIBLE;
							if (_videoPlayer) _videoPlayer.mute	= false;
							break;
							
						case AudioControlButtonState.AUDIBLE:
							target.state = AudioControlButtonState.MUTED;
							if (_videoPlayer) _videoPlayer.mute	= true;
							break;
							
					}
				}
			} else 
			{
				switch (event.currentTarget) 
				{
					
					case _fastForwardButton:
						if (_videoPlayer) _videoPlayer.seek(_videoPlayer.duration);
						break;
						
					case _fastRewindButton:
						if (_videoPlayer) _videoPlayer.seek(0);
						break;
						
					case _forwardButton:
						if (_videoPlayer) _videoPlayer.seek((_videoPlayer.time <= _videoPlayer.duration - 5)? _videoPlayer.time + 5: _videoPlayer.duration);
						break;
						
					case _rewindButton:
						if (_videoPlayer) _videoPlayer.seek((_videoPlayer.time >= 5)? _videoPlayer.time - 5: 0);
						break;
						
				}
			}
		}
		
		/**
		 * pageOpenHandler :: Event listener upon the opening of the listened page.
		 * @param	event	<PageManagerEvent>	Event dispatched from the particular page upon opening.
		 */
		protected function pageOpenHandler(event:PageManagerEvent):void 
		{
			if (_playingPausedButton) _playingPausedButton.state = VideoControlButtonState.PLAYING;
			if (videoPlayer) videoPlayer.resume();
		}
		
		/**
		 * pageCloseHandler :: Event listener upon the closing of the listened page.
		 * @param	event	<PageManagerEvent>	Event dispatched from the particular page upon closing.
		 */
		protected function pageCloseHandler(event:PageManagerEvent):void 
		{
			if (_playingPausedButton) _playingPausedButton.state = VideoControlButtonState.PAUSED;
			if (videoPlayer) videoPlayer.pause();
		}
		
		/**
		 * assignListener :: Add event listeners to the available page.
		 */
		protected function assignListener():void 
		{
			_dispatcher.addEventListener(PageManagerEvent.CLOSE, pageCloseHandler);
			_dispatcher.addEventListener(PageManagerEvent.OPEN, pageOpenHandler);
		}
		
		/**
		 * removeListener :: remove the current event listeners from the available page.
		 */
		protected function removeListener():void 
		{
			_dispatcher.removeEventListener(PageManagerEvent.CLOSE, pageCloseHandler);
			_dispatcher.removeEventListener(PageManagerEvent.OPEN, pageOpenHandler);
		}
		
	}
	
}