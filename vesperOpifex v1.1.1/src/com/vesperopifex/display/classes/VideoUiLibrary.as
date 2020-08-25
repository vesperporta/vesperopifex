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
package com.vesperopifex.display.classes 
{
	import com.vesperopifex.utils.Settings;
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class VideoUiLibrary extends Sprite 
	{
		// mxmlc com\vesperopifex\display\classes\VideoUiLibrary.as -output ..\bin\assets\swf\video-ui-resources.swf -sp . -use-network=false
		
		[Embed(source='../../../../ui-library-video.swf', symbol='PlayingStateButton')]
		public var PlayingButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='InactivePlayingStateButton')]
		public var InactivePlayingButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='PausedStateButton')]
		public var PausedButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='InactivePausedStateButton')]
		public var InactivePausedButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='MutedStateButton')]
		public var MutedButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='InactiveMutedStateButton')]
		public var InactiveMutedButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='AudibleStateButton')]
		public var AudibleButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='InactiveAudibleStateButton')]
		public var InactiveAudibleButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='ForwardButton')]
		public var ForwardButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='InactiveForwardButton')]
		public var InactiveForwardButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='FastForwardButton')]
		public var FastForwardButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='InactiveFastForwardButton')]
		public var InactiveFastForwardButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='RewindButton')]
		public var RewindButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='InactiveRewindButton')]
		public var InactiveRewindButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='FastRewindButton')]
		public var FastRewindButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='InactiveFastRewindButton')]
		public var InactiveFastRewindButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='SeekingStateButton')]
		public var SeekingStateButton:Class;
		
		[Embed(source='../../../../ui-library-video.swf', symbol='InactiveSeekingStateButton')]
		public var InactiveSeekingStateButton:Class;
		
		/**
		 * Constructor
		 */
		public function VideoUiLibrary() 
		{
			trace("ExternalLibraryClass\t:\t" + this);
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}
		
	}
	
}