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
package com.vesperopifex.display.book 
{
	import com.vesperopifex.display.GraphicComponentObject;
	import com.vesperopifex.display.GraphicFactory;
	import com.vesperopifex.display.IXMLDataObject;
	import com.vesperopifex.events.AnimatorEvent;
	import com.vesperopifex.tweens.AnimatorObject;
	import com.vesperopifex.tweens.XMLAnimation;
	import com.vesperopifex.events.PageManagerEvent;
	import com.vesperopifex.utils.controllers.PageEventControl;
	import com.vesperopifex.xml.XMLFactory;
	import fl.motion.Animator;
	import fl.motion.MotionEvent;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	public class GraphicAnimatedPage extends GraphicPage 
	{
		protected static const CLOSED_STATE:String		= "closed";
		protected static const CLOSING_STATE:String		= "closing";
		protected static const OPENED_STATE:String		= "opened";
		protected static const OPENING_STATE:String		= "opening";
		
		protected var _animationState:String			= CLOSED_STATE;
		protected var _stateAnimations:int				= 0;
		protected var _completedStateAnimations:int		= 0;
		
		/**
		 * GraphicAnimatedComponent :: Constructor.
		 */
		public function GraphicAnimatedPage(id:String, xml:XML) 
		{
			super(id, xml);
			if (_persitent) 
			{
				visible			= true;
				_handleComplete	= false;
				generateGraphics();
				animateOpenHandler();
				_handleComplete	= true;
				_initiated		= true;
			}
		}
		
		/**
		 * openPage :: override to run intro animation
		 */
		protected override function openPage():void 
		{
			if (!visible) visible	= true;
			super.openPage();
		}
		
		/**
		 * checkPageXMLIndex :: check through all the Components on the GraphicComponent and make sure the display index is correct for all GraphicPage objects.
		 */
		protected override function checkPageXMLIndex():void
		{
			_children.push(new GraphicComponentObject(this, -1, _data));
			super.checkPageXMLIndex();
		}
		
		/**
		 * animateOpenHandler :: do any animations to display the page
		 */
		protected override function animateOpenHandler():void
		{
			var gObject:GraphicComponentObject	= null;
			var animObject:AnimatorObject		= null;
			var animatedObject:Boolean			= false;
			var item:XML						= null;
			_animationState						= OPENING_STATE;
			if (_handleComplete) 
				for each (animObject in XMLAnimation.ANIMATORS) 
					animObject.animator.addEventListener(AnimatorEvent.COMPLETE, animatorOpenCompleteEventHandler);
			for each (gObject in _children) 
			{
				if (!gObject.data) continue;
				for each (item in gObject.data.children()) 
				{
					if (!XMLAnimation.checkAnimationXML(item)) continue;
					animatedObject				= XMLAnimation.animate(gObject.graphic, PageEventControl.CONTEXT_ANIMATION_OPEN, item);
					if (animatedObject) 
					{
						_stateAnimations++;
						animatedObject			= false;
					}
				}
			}
			if (!_stateAnimations) 
			{
				_animationState					= OPENED_STATE;
				for each (animObject in XMLAnimation.ANIMATORS) 
					animObject.animator.removeEventListener(AnimatorEvent.COMPLETE, animatorOpenCompleteEventHandler);
				super.animateOpenHandler();
			}
		}
		
		/**
		 * animatorOpenCompleteEventHandler :: handle the event dispatches from animations opening the page.
		 * @param	event	<AnimatorEvent>	the event dispatched from teh animation class.
		 */
		protected function animatorOpenCompleteEventHandler(event:AnimatorEvent):void 
		{
			if (event.cancelable) event.stopImmediatePropagation();
			_completedStateAnimations++;
			if (_completedStateAnimations == _stateAnimations) 
			{
				_animationState					= OPENED_STATE;
				for each (var animObject:AnimatorObject in XMLAnimation.ANIMATORS) animObject.animator.removeEventListener(AnimatorEvent.COMPLETE, animatorOpenCompleteEventHandler);
				resetAnimation();
				activateObjects();
				super.animateOpenHandler();
			}
		}
		
		/**
		 * animateCloseHandler :: parent node closing animation.
		 */
		protected override function animateCloseHandler():void 
		{
			if (_animationState == OPENING_STATE) 
			{
				addEventListener(PageManagerEvent.OPEN, animateDirectCloseHandler);
				return;
			}
			var gObject:GraphicComponentObject	= null;
			var animObject:AnimatorObject		= null;
			var animatedObject:Boolean			= false;
			var item:XML						= null;
			_animationState						= CLOSING_STATE;
			if (_handleComplete) 
				for each (animObject in XMLAnimation.ANIMATORS) 
					animObject.animator.addEventListener(AnimatorEvent.COMPLETE, animatorCloseCompleteEventHandler);
			for each (gObject in _children) 
			{
				if (!gObject.data) continue;
				for each (item in gObject.data.children()) 
				{
					if (!XMLAnimation.checkAnimationXML(item)) continue;
					animatedObject				= XMLAnimation.animate(gObject.graphic, PageEventControl.CONTEXT_ANIMATION_CLOSE, item);
					if (animatedObject) 
					{
						_stateAnimations++;
						animatedObject			= false;
					}
				}
			}
			if (!_stateAnimations) 
			{
				_animationState					= CLOSED_STATE;
				for each (animObject in XMLAnimation.ANIMATORS) 
					animObject.animator.removeEventListener(AnimatorEvent.COMPLETE, animatorCloseCompleteEventHandler);
				super.animateCloseHandler();
			}
		}
		
		/**
		 * animateDirectCloseHandler :: event handler to find if the page should close directly after animating open.
		 * @param	event	<PageManagerEvent>
		 */
		protected function animateDirectCloseHandler(event:PageManagerEvent):void 
		{
			if (event.cancelable) event.stopImmediatePropagation();
			removeEventListener(PageManagerEvent.OPEN, animateDirectCloseHandler);
			close();
		}
		
		/**
		 * animatorCloseCompleteEventHandler :: handle the event dispatches from animations closing the page.
		 * @param	event	<AnimatorEvent> the event dispatched from the animator.
		 */
		protected function animatorCloseCompleteEventHandler(event:AnimatorEvent):void 
		{
			if (event.cancelable) event.stopImmediatePropagation();
			_completedStateAnimations++;
			if (_completedStateAnimations == _stateAnimations) 
			{
				_animationState					= CLOSED_STATE;
				var animObject:AnimatorObject	= null;
				
				for each (animObject in XMLAnimation.ANIMATORS) 
					animObject.animator.removeEventListener(AnimatorEvent.COMPLETE, animatorCloseCompleteEventHandler);
				
				resetAnimation();
				super.animateCloseHandler();
			}
		}
		
		/**
		 * activateObjects :: for all objects which have the availability to activate and deactivate, the Boolean value passed will be used to activate [true] or deactivate [false].
		 * @param	active	<Boolean>	switch value to turn object from or to an inactive or active state.
		 */
		protected function activateObjects(active:Boolean = true):void 
		{
			for each (var object:GraphicComponentObject in _children) 
				if (object is IXMLDataObject) 
					(object.graphic as IXMLDataObject).active = active;
		}
		
		/**
		 * resetAnimation :: reset any animation values.
		 */
		protected function resetAnimation():void 
		{
			resetAnimationCount();
		}
		
		/**
		 * resetAnimationCount :: reset counting variables for animations.
		 */
		protected function resetAnimationCount():void 
		{
			_stateAnimations			= 0;
			_completedStateAnimations	= 0;
		}
		
		/**
		 * opened :: final call to open the page.
		 */
		protected override function opened():void 
		{
			super.opened();
		}
		
		/**
		 * closed :: final call when closing the current page.
		 */
		protected override function closed():void 
		{
			super.closed();
			if (_persitent) visible	= true;
		}
		
	}
	
}