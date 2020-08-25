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
	import com.vesperopifex.display.DataRetrieve;
	import com.vesperopifex.display.RSSDisplayObject;
	import com.vesperopifex.display.SimpleInformationPanel;
	import com.vesperopifex.display.ui.DataButton;
	import com.vesperopifex.display.ui.SimpleScrollBar;
	import com.vesperopifex.tweens.AdobeAnimator;
	import com.vesperopifex.utils.Settings;
	import com.vesperopifex.utils.SWFAddressObject;
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class UiLibrary extends Sprite 
	{
		// mxmlc com\vesperopifex\display\classes\UiLibrary.as -output ..\bin\assets\swf\ui-resources.swf -sp . -use-network=false
		// mxmlc com/vesperopifex/display/classes/UiLibrary.as -output ../bin/assets/swf/ui-resources.swf -sp . -use-network=false
		
		// RSS feed reader
		public var RSSFeedReader:Class				= RSSDisplayObject;
		
		// SimpleScrollBar
		public var GenericScrollBar:Class			= SimpleScrollBar;
		
		// SimpleInformationPanel
		public var GenericInformationPanel:Class	= SimpleInformationPanel;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='LogoVisual')]
		public var LogoVisual:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='LogoVisualBounds')]
		public var LogoVisualBounds:Class;
		
		// swfAddress handler for browsing interaction
		public var BrowserInteraction:Class			= SWFAddressObject;
		
		// TEST for IDataObject sending and retrieval.
		public var DataButtonSender:Class			= DataButton;
		public var DataReciever:Class				= DataRetrieve;
		
		public var FLPackageAnimator:Class			= AdobeAnimator;
		
		// scroll bar elements
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalBackground')]
		public var VerticalScrollBackground:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalBackground_inactive')]
		public var VerticalScrollBackgroundInactive:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalScrub')]
		public var VerticalScrollScrub:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalScrub_over')]
		public var VerticalScrollScrubOver:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalScrub_down')]
		public var VerticalScrollScrubDown:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalScrub_inactive')]
		public var VerticalScrollScrubInactive:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalUp')]
		public var VerticalScrollUp:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalUp_over')]
		public var VerticalScrollUpOver:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalUp_down')]
		public var VerticalScrollUpDown:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalUp_inactive')]
		public var VerticalScrollUpInactive:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalUpEnd')]
		public var VerticalScrollUpEnd:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalUpEnd_over')]
		public var VerticalScrollUpEndOver:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalUpEnd_down')]
		public var VerticalScrollUpEndDown:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalUpEnd_inactive')]
		public var VerticalScrollUpEndInactive:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalDown')]
		public var VerticalScrollDown:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalDown_over')]
		public var VerticalScrollDownOver:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalDown_down')]
		public var VerticalScrollDownDown:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalDown_inactive')]
		public var VerticalScrollDownInactive:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalDownEnd')]
		public var VerticalScrollDownEnd:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalDownEnd_over')]
		public var VerticalScrollDownEndOver:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalDownEnd_down')]
		public var VerticalScrollDownEndDown:Class;
		
		[Embed(source='../../../../ui-library-graphics.swf', symbol='ScrollVerticalDownEnd_inactive')]
		public var VerticalScrollDownEndInactive:Class;
		
		/**
		 * Constructor
		 */
		public function UiLibrary() 
		{
			trace("ExternalLibraryClass\t:\t" + this);
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}
		
	}
	
}