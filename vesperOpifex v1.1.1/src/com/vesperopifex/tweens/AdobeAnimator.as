/**
 * @author:		Laurence Green
 * @email:		contact@laurencegreen.com
 * @email:		vesper.opifex@googlemail.com
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
package com.vesperopifex.tweens 
{
	import com.vesperopifex.events.AnimatorEvent;
	import fl.motion.Animator;
	import fl.motion.MotionEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class AdobeAnimator extends Sprite implements IAnimator 
	{
		protected var _animators:Array	= new Array();
		
		public function get animationList():Array { return null; } /// this is not complete, pass through all the avilable tweens and return them. currently not vital.
		
		public function AdobeAnimator() 
		{
			super();
		}
		
		/**
		 * animateDisplayObject :: generate the available aniamtions described in the XML and make the passed DisplayObject animate to the requirements, and in the limitations of the Tweening class, this is handled by the implimenting Class.
		 * @param	displayObject	<DisplayObject>	the graphical object on which the animation is to be placed upon.
		 * @param	data	<XML>	the data containing all the animation information.
		 * @return	<Boolean>	a value to determin if the aniamtion has successfully been applied to the DisplayObject, true, or not, false.
		 */
		public function animateDisplayObject(displayObject:DisplayObject, data:XML):Boolean 
		{
			var animator:Animator	= new Animator(data, displayObject);
			_animators.push(animator);
			animator.addEventListener("motionUpdate", motionUpdateEventHandler);
			animator.addEventListener("timeChange", timeChangeEventHandler);
			animator.addEventListener("motionEnd", motionEndEventHandler);
			animator.addEventListener("motionStart", motionStartEventHandler);
			animator.play();
			return Boolean(animator.isPlaying);
		}
		
		/**
		 * dispatcher for when the tween has started.
		 * @param	event	<Event> the event dispatched from the Animator class.
		 */
		protected function motionStartEventHandler(event:Event):void 
		{
			if (hasEventListener(AnimatorEvent.START)) 
			{
				var animator:Animator	= event.target as Animator;
				dispatchEvent(new AnimatorEvent(AnimatorEvent.START, true, false, animator.target, null));
			}
		}
		
		/**
		 * dispatcher for when the tween has finished.
		 * @param	event	<Event> the event dispatched from the Animator class.
		 */
		protected function motionEndEventHandler(event:Event):void 
		{
			if (hasEventListener(AnimatorEvent.COMPLETE)) 
			{
				var animator:Animator	= event.target as Animator;
				dispatchEvent(new AnimatorEvent(AnimatorEvent.COMPLETE, true, false, animator.target, null));
			}
		}
		
		/**
		 * dispatcher for when the tween time has changed.
		 * @param	event	<Event> the event dispatched from the Animator class.
		 */
		protected function timeChangeEventHandler(event:Event):void 
		{
			
		}
		
		/**
		 * dispatcher for when the tween has been update.
		 * @param	event	<Event> the event dispatched from the Animator class.
		 */
		protected function motionUpdateEventHandler(event:Event):void 
		{
			if (hasEventListener(AnimatorEvent.UPDATE)) 
			{
				var animator:Animator	= event.target as Animator;
				dispatchEvent(new AnimatorEvent(AnimatorEvent.UPDATE, true, false, animator.target, null));
			}
		}
		
		/**
		 * clear :: if there is no DisplayObject passed in as a paramater then all animations of the implementing Class is to stop all aniamtions and remove any reference of such an animation, otherwise if a DisplayObject is passed then the animation, if any, placed upon that object is stopped and removed from the framework.
		 * @param	displayObject	<DisplayObject [default null]>	the object on which to remove current animations.
		 * @return	<Boolean>	a value to determin if any animations where removed from any objects.
		 */
		public function clear(displayObject:DisplayObject = null):Boolean 
		{
			var animator:Animator	= null;
			for each (animator in _animators) 
			{
				if (displayObject) 
				{
					if (animator.target == displayObject) 
					{
						animator.pause();
						animator	= null;
						return true;
					}
				} else 
				{
					animator.pause();
					animator	= null;
				}
			}
			return (!displayObject)? true: false;
		}
		
		/**
		 * pause :: stop the current animations on all objects currently in operation if the displayObject is null otherwise stop all animations on the object passed, this method is a temporary pause in animation where the method 'resume' can be employed to start the animations from where they where stopped.
		 * @param	displayObject	<DisplayObject [default null]>	the object on which to stop the animations.
		 * @return	<Boolean>	a value to determin if any animatiosn where stopped or not.
		 */
		public function pause(displayObject:DisplayObject = null):Boolean 
		{
			var animator:Animator	= null;
			for each (animator in _animators) 
			{
				if (displayObject) 
				{
					if (animator.target == displayObject) 
					{
						animator.pause();
						return true;
					}
				} else 
					animator.pause();
			}
			return (!displayObject)? true: false;
		}
		
		/**
		 * resume :: after the use of pause this method can be used to resume the effected animations from their previous tween point.
		 * @param	displayObject	<DisplayObject [default null]>	the object with which to resume the animation.
		 * @return	<Boolean>	a value to determine if there where any animations resumed or not.
		 */
		public function resume(displayObject:DisplayObject = null):Boolean 
		{
			var animator:Animator	= null;
			for each (animator in _animators) 
			{
				if (displayObject) 
				{
					if (animator.target == displayObject) 
					{
						animator.resume();
						return true;
					}
				} else 
					animator.resume();
			}
			return (!displayObject)? true: false;
		}
		
	}
	
}