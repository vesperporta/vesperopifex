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
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	import com.vesperopifex.events.AnimatorEvent;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	public class TweenerAnimator extends EventDispatcher implements IAnimator 
	{
		public static const QNAME:String				= "tweener";
		public static const TRANSITION:String			= "transition";
		public static const DATA_ID:String				= "id";
		
		public static const EASE_NONE:String			= "easenone";
		public static const LINEAR:String				= "linear";
		
		public static const EASE_IN_QUAD:String			= "easeinquad";
		public static const EASE_OUT_QUAD:String		= "easeoutquad";
		public static const EASE_IN_OUT_QUAD:String		= "easeinoutquad";
		public static const EASE_OUT_IN_QUAD:String		= "easeoutinquad";
		
		public static const EASE_IN_CUBIC:String		= "easeincubic";
		public static const EASE_OUT_CUBIC:String		= "easeoutcubic";
		public static const EASE_IN_OUT_CUBIC:String	= "easeinoutcubic";
		public static const EASE_OUT_IN_CUBIC:String	= "easeoutincubic";
		
		public static const EASE_IN_QUART:String		= "easeinquart";
		public static const EASE_OUT_QUART:String		= "easeoutquart";
		public static const EASE_IN_OUT_QUART:String	= "easeinoutquart";
		public static const EASE_OUT_IN_QUART:String	= "easeoutinquart";
		
		public static const EASE_IN_QUINT:String		= "easeinquint";
		public static const EASE_OUT_QUINT:String		= "easeoutquint";
		public static const EASE_IN_OUT_QUINT:String	= "easeinoutquint";
		public static const EASE_OUT_IN_QUINT:String	= "easeoutinquint";
		
		public static const EASE_IN_SINE:String			= "easeinsine";
		public static const EASE_OUT_SINE:String		= "easeoutsine";
		public static const EASE_IN_OUT_SINE:String		= "easeinoutsine";
		public static const EASE_OUT_IN_SINE:String		= "easeoutinsine";
		
		public static const EASE_IN_CIRC:String			= "easeincirc";
		public static const EASE_OUT_CIRC:String		= "easeoutcirc";
		public static const EASE_IN_OUT_CIRC:String		= "easeinoutcirc";
		public static const EASE_OUT_IN_CIRC:String		= "easeoutincirc";
		
		public static const EASE_IN_EXPO:String			= "easeinexpo";
		public static const EASE_OUT_EXPO:String		= "easeoutexpo";
		public static const EASE_IN_OUT_EXPO:String		= "easeinoutexpo";
		public static const EASE_OUT_IN_EXPO:String		= "easeoutinexpo";
		
		public static const EASE_IN_ELASTIC:String		= "easeinelastic";
		public static const EASE_OUT_ELASTIC:String		= "easeoutelastic";
		public static const EASE_IN_OUT_ELASTIC:String	= "easeinoutelastic";
		public static const EASE_OUT_IN_ELASTIC:String	= "easeoutinelastic";
		
		public static const EASE_IN_BACK:String			= "easeinback";
		public static const EASE_OUT_BACK:String		= "easeoutback";
		public static const EASE_IN_OUT_BACK:String		= "easeinoutback";
		public static const EASE_OUT_IN_BACK:String		= "easeoutinback";
		
		public static const EASE_IN_BOUNCE:String		= "easeinbounce";
		public static const EASE_OUT_BOUNCE:String		= "easeoutbounce";
		public static const EASE_IN_OUT_BOUNCE:String	= "easeinoutbounce";
		public static const EASE_OUT_IN_BOUNCE:String	= "easeoutinbounce";
		
		public function get animationList():Array { return null; } /// this is not complete, pass through all the avilable tweens and return them. currently not vital.
		
		/**
		 * TweenerAnimator :: Constructor.
		 */
		public function TweenerAnimator() 
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
			var object:Object	=	{ 
										onStart: tweenerStartHandler,
										onStartParams: [displayObject, data],
										onUpdate: tweenerUpdateHandler,
										onUpdateParams: [displayObject, data],
										onComplete: tweenerComlpeteHandler, 
										onCompleteParams: [displayObject, data], 
										onOverwrite: tweenerOverwriteHandler,
										onOverwriteParams: [displayObject, data] 
									};
			object.time			= 2;
			object.delay		= 0;
			object.useFrames	= false;
			object.transition	= EASE_OUT_EXPO;
			object				= applyParamaterDetails(object, data);
			return Tweener.addTween(displayObject, object);
		}
		
		/**
		 * applyParamaterDetails :: pass through the available XML data and determin what available paramaters to add or overwrite will be placed on teh passed Object.
		 * @param	object	<Object>	the object to be actioned upon by being overwriten or added to.
		 * @param	data	<XML>	the data containing the information regarding the animation.
		 */
		protected function applyParamaterDetails(object:Object, data:XML):Object
		{
			var item:XML	= null;
			for each (item in data.attributes()) 
			{
				switch (String(item.name())) 
				{
					case DATA_ID:
						break;
					case XMLAnimation.XML_ANIM_REF:
						break;
					case XMLAnimation.XML_ANIMATOR_ATT:
						break;
					case TRANSITION:
						if (transitionAvailable(String(item))) object[String(item.name())]	= transitionFunction(String(item));
						break;
					default:
						object[String(item.name())]	= item;
						break;
				}
			}
			for each (item in data.children()) 
			{
				switch (String(item.name())) 
				{
					case DATA_ID:
						break;
					case XMLAnimation.XML_ANIM_REF:
						break;
					case XMLAnimation.XML_ANIMATOR_ATT:
						break;
					case TRANSITION:
						if (transitionAvailable(String(item))) object[String(item.name())]	= item;
						break;
					default:
						object[String(item.name())]	= item;
						break;
				}
			}
			return object;
		}
		
		/**
		 * An event handler and dispatcher when the tween has been updated.
		 * @param	displayObject	<DisplayObject>	the object to target for the tween.
		 * @param	data	<XML>	the data pertaining to the tween.
		 */
		protected function tweenerUpdateHandler(displayObject:DisplayObject = null, data:XML = null):void
		{
			if (hasEventListener(AnimatorEvent.UPDATE)) 
				dispatchEvent(new AnimatorEvent(AnimatorEvent.UPDATE, true, false, displayObject, data));
		}
		
		/**
		 * An event handler and dispatcher upon the start of the tween.
		 * @param	displayObject	<DisplayObject>	the object to target for the tween.
		 * @param	data	<XML>	the data pertaining to the tween.
		 */
		protected function tweenerStartHandler(displayObject:DisplayObject = null, data:XML = null):void
		{
			if (hasEventListener(AnimatorEvent.START)) 
				dispatchEvent(new AnimatorEvent(AnimatorEvent.START, true, false, displayObject, data));
		}
		
		/**
		 * An event handler and dispatcher for the completion of the tween.
		 * @param	displayObject	<DisplayObject>	the object to target for the tween.
		 * @param	data	<XML>	the data pertaining to the tween.
		 */
		protected function tweenerComlpeteHandler(displayObject:DisplayObject = null, data:XML = null):void
		{
			if (hasEventListener(AnimatorEvent.COMPLETE)) 
				dispatchEvent(new AnimatorEvent(AnimatorEvent.COMPLETE, true, false, displayObject, data));
		}
		
		/**
		 * An event handler and dispatcher for any attributes to a tween upon overwriting of any attribute.
		 * @param	displayObject	<DisplayObject>	the object to target for the tween.
		 * @param	data	<XML>	the data pertaining to the tween.
		 */
		protected function tweenerOverwriteHandler(displayObject:DisplayObject = null, data:XML = null):void
		{
			if (hasEventListener(AnimatorEvent.OVERWRITE)) 
				dispatchEvent(new AnimatorEvent(AnimatorEvent.OVERWRITE, true, false, displayObject, data));
		}
		
		/**
		 * clear :: if there is no DisplayObject passed in as a paramater then all animations of the implementing Class is to stop all aniamtions and remove any reference of such an animation, otherwise if a DisplayObject is passed then the animation, if any, placed upon that object is stopped and removed from the framework.
		 * @param	displayObject	<DisplayObject [default null]>	the object on which to remove current animations.
		 * @return	<Boolean>	a value to determin if any animations where removed from any objects.
		 */
		public function clear(displayObject:DisplayObject = null):Boolean 
		{
			if (displayObject) return Tweener.removeTweens(displayObject);
			return Tweener.removeAllTweens();
		}
		
		/**
		 * pause :: stop the current animations on all objects currently in operation if the displayObject is null otherwise stop all animations on the object passed, this method is a temporary pause in animation where the method 'resume' can be employed to start the animations from where they where stopped.
		 * @param	displayObject	<DisplayObject [default null]>	the object on which to stop the animations.
		 * @return	<Boolean>	a value to determin if any animatiosn where stopped or not.
		 */
		public function pause(displayObject:DisplayObject = null):Boolean 
		{
			if (displayObject) return Tweener.pauseTweens(displayObject);
			return Tweener.pauseAllTweens();
		}
		
		/**
		 * resume :: after the use of pause this method can be used to resume the effected animations from their previous tween point.
		 * @param	displayObject	<DisplayObject [default null]>	the object with which to resume the animation.
		 * @return	<Boolean>	a value to determine if there where any animations resumed or not.
		 */
		public function resume(displayObject:DisplayObject = null):Boolean 
		{
			if (displayObject) return Tweener.resumeTweens(displayObject);
			return Tweener.resumeAllTweens();
		}
		
		/**
		 * transitionAvailable :: find if the passed transition id is a registered transition with the Tweener class.
		 * @param	value	<String>	the String value of the transition to be used.
		 * @return	<Boolean>	if the transition is registered then true is returned and if not then false is returned.
		 */
		protected function transitionAvailable(value:String):Boolean
		{
			if (value == EASE_NONE || 
				value == LINEAR || 
				value == EASE_IN_QUAD || 
				value == EASE_OUT_QUAD || 
				value == EASE_IN_OUT_QUAD || 
				value == EASE_OUT_IN_QUAD || 
				value == EASE_IN_CUBIC || 
				value == EASE_OUT_CUBIC || 
				value == EASE_IN_OUT_CUBIC || 
				value == EASE_OUT_IN_CUBIC || 
				value == EASE_IN_QUART || 
				value == EASE_OUT_QUART || 
				value == EASE_IN_OUT_QUART || 
				value == EASE_OUT_IN_QUART || 
				value == EASE_IN_QUINT || 
				value == EASE_OUT_QUINT || 
				value == EASE_IN_OUT_QUINT || 
				value == EASE_OUT_IN_QUINT || 
				value == EASE_IN_SINE || 
				value == EASE_OUT_SINE || 
				value == EASE_IN_OUT_SINE || 
				value == EASE_OUT_IN_SINE || 
				value == EASE_IN_CIRC || 
				value == EASE_OUT_CIRC || 
				value == EASE_IN_OUT_CIRC || 
				value == EASE_OUT_IN_CIRC || 
				value == EASE_IN_EXPO || 
				value == EASE_OUT_EXPO || 
				value == EASE_IN_OUT_EXPO || 
				value == EASE_OUT_IN_EXPO || 
				value == EASE_IN_ELASTIC || 
				value == EASE_OUT_ELASTIC || 
				value == EASE_IN_OUT_ELASTIC || 
				value == EASE_OUT_IN_ELASTIC || 
				value == EASE_IN_BACK || 
				value == EASE_OUT_BACK || 
				value == EASE_IN_OUT_BACK || 
				value == EASE_OUT_IN_BACK || 
				value == EASE_IN_BOUNCE || 
				value == EASE_OUT_BOUNCE || 
				value == EASE_IN_OUT_BOUNCE || 
				value == EASE_OUT_IN_BOUNCE)
					return true;
			return false;
		}
		
		/**
		 * transitionFunction :: return the function associated with the tweening equation identifier.
		 * @param	value	<String>	the tweening equation identifier.
		 * @return	<Function>	the equation for tweening purposes.
		 */
		protected function transitionFunction(value:String):Function 
		{
			switch (value) 
			{
				
				case EASE_NONE:
					return Equations.easeNone;
					
				case LINEAR:
					return Equations.easeNone;
					
				case EASE_IN_QUAD:
					return Equations.easeInQuad;
					
				case EASE_OUT_QUAD:
					return Equations.easeOutQuad;
					
				case EASE_IN_OUT_QUAD:
					return Equations.easeInOutQuad;
					
				case EASE_OUT_IN_QUAD:
					return Equations.easeOutInQuad;
					
				case EASE_IN_CUBIC:
					return Equations.easeInCubic;
					
				case EASE_OUT_CUBIC:
					return Equations.easeOutCubic;
					
				case EASE_IN_OUT_CUBIC:
					return Equations.easeInOutCubic;
					
				case EASE_OUT_IN_CUBIC:
					return Equations.easeOutInCubic;
					
				case EASE_IN_QUART:
					return Equations.easeInQuart;
					
				case EASE_OUT_QUART:
					return Equations.easeOutQuart;
					
				case EASE_IN_OUT_QUART:
					return Equations.easeInOutQuart;
					
				case EASE_OUT_IN_QUART:
					return Equations.easeOutInQuart;
					
				case EASE_IN_QUINT:
					return Equations.easeInQuint;
					
				case EASE_OUT_QUINT:
					return Equations.easeOutQuint;
					
				case EASE_IN_OUT_QUINT:
					return Equations.easeInOutQuint;
					
				case EASE_OUT_IN_QUINT:
					return Equations.easeOutInQuint;
					
				case EASE_IN_SINE:
					return Equations.easeInSine;
					
				case EASE_OUT_SINE:
					return Equations.easeOutSine;
					
				case EASE_IN_OUT_SINE:
					return Equations.easeInOutSine;
					
				case EASE_OUT_IN_SINE:
					return Equations.easeOutInSine;
					
				case EASE_IN_CIRC:
					return Equations.easeInCirc;
					
				case EASE_OUT_CIRC:
					return Equations.easeOutCirc;
					
				case EASE_IN_OUT_CIRC:
					return Equations.easeInOutCirc;
					
				case EASE_OUT_IN_CIRC:
					return Equations.easeOutInCirc;
					
				case EASE_IN_EXPO:
					return Equations.easeInExpo;
					
				case EASE_OUT_EXPO:
					return Equations.easeOutExpo;
					
				case EASE_IN_OUT_EXPO:
					return Equations.easeInOutExpo;
					
				case EASE_OUT_IN_EXPO:
					return Equations.easeOutInExpo;
					
				case EASE_IN_ELASTIC:
					return Equations.easeInElastic;
					
				case EASE_OUT_ELASTIC:
					return Equations.easeOutElastic;
					
				case EASE_IN_OUT_ELASTIC:
					return Equations.easeInOutElastic;
					
				case EASE_OUT_IN_ELASTIC:
					return Equations.easeOutInElastic;
					
				case EASE_IN_BACK:
					return Equations.easeInBack;
					
				case EASE_OUT_BACK:
					return Equations.easeOutBack;
					
				case EASE_IN_OUT_BACK:
					return Equations.easeInOutBack;
					
				case EASE_OUT_IN_BACK:
					return Equations.easeOutInBack;
					
				case EASE_IN_BOUNCE:
					return Equations.easeInBounce;
					
				case EASE_OUT_BOUNCE:
					return Equations.easeOutBounce;
					
				case EASE_IN_OUT_BOUNCE:
					return Equations.easeInOutBounce;
					
				case EASE_OUT_IN_BOUNCE:
					return Equations.easeOutInBounce;
					
			}
			return null;
		}
		
	}
	
}