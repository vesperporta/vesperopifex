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
package com.vesperopifex.tweens 
{
	import com.vesperopifex.display.GraphicComponentObject;
	import com.vesperopifex.events.AnimatorEvent;
	import com.vesperopifex.events.GraphicFactoryEvent;
	import com.vesperopifex.utils.XMLGraphicDisplay;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class XMLAnimation extends EventDispatcher 
	{
		public static const XML_COMPILE_NODE:String			= "animationdata";
		public static const XML_TWEEN_NODE:String			= "tween";
		public static const XML_ANIMATOR_ATT:String			= "animator";
		public static const XML_EVENT_ID:String				= "id";
		public static const XML_ANIM_REF:String				= "lib";
		
		protected static const XML_I_ANIM:String			= "iAnimator";
		protected static const XML_I_ANIM_QNAME:String		= "qName";
		
		/* extend this Array object to allow for a larger availability of animators.
		 * place a comma at the end of each and generate a new line, remove the comma from the very last line to complete the Array syntax.
			[
				new AnimatorObject(TweenerAnimator.QNAME, new TweenerAnimator()),
				new AnimatorObject(TweenerAnimator.QNAME, new TweenerAnimator())
			];
		 */
		protected static var _ANIMATORS:Array				=	[
																	new AnimatorObject(TweenerAnimator.QNAME, new TweenerAnimator()) 
																];
		protected static var _loadingAnimators:Array		= null;
		protected static var _data:XML						= null;
		protected static var _dispatcher:EventDispatcher	= new EventDispatcher();
		protected static var _animating:Boolean				= false;
		protected static var _animations:int				= 0;
		protected static var _listenedAnimators:Dictionary	= new Dictionary();
		
		public static function get ANIMATORS():Array { return _ANIMATORS; }
		
		public static function get data():XML { return _data; }
		public static function set data(value:XML):void 
		{
			_data = value;
			passAnimationXML(_data);
		}
		
		public static function get loading():Boolean { return Boolean(_loadingAnimators); }
		
		static public function get dispatcher():EventDispatcher { return _dispatcher; }
		
		static public function get animating():Boolean { return _animating; }
		
		/**
		 * XMLAnimation :: a public static Class to generate the various animations for the DisplayObject targets requested.
		 */
		public function XMLAnimation() 
		{
			throw new ArgumentError("com.vesperopifex.tweens.XMLAnimation is not to be instanced!\nThis is a 'static' Class and should be used as such.");
		}
		
		/**
		 * checkAnimationXML :: runs through all the available XML and finds data nodes with the corresponding QName and returns true, otherwise if no data is found flase is returned.
		 * @param	data	<XML> the data containing the animation data.
		 * @return	<Booolean>	returns true if animation data is found and false if no animation data found.
		 */
		public static function checkAnimationXML(data:XML):Boolean 
		{
			var rtn:Boolean				= false;
			var item:XML				= null;
			var object:AnimatorObject	= null;
			for each (object in _ANIMATORS) 
			{
				for each (item in data[object.name]) 
				{
					if (item.@[XML_ANIM_REF].length()) collateAnimationData(item);
					if (!rtn) rtn		= true;
				}
				for each (item in data[XML_TWEEN_NODE]) 
				{
					if (String(item.@[XML_ANIMATOR_ATT]) == object.name) collateAnimationData(item);
					if (!rtn) rtn		= true;
				}
			}
			return rtn;
		}
		
		/**
		 * collateAnimationData
		 * @param	data	<XML>	the data to pass through and find matching objects in the stored data set and append any additional information for specific tweens.
		 * @return	<XML>	the compiled data.
		 */
		private static function collateAnimationData(data:XML):XML 
		{
			if (!_data) return null;
			var item:XML				= null;
			var att:XML					= null;
			for each (item in _data.children()) 
			{
				if (String(data.@[XML_ANIM_REF]) == String(item.@[XML_EVENT_ID])) 
				{
					for each (att in item.attributes()) 
						if (!data.@[String(att.name())].length() && String(att.name()) != XML_EVENT_ID) 
							data.@[String(att.name())]	= att;
					for each (att in item.children()) 
						if (!data[String(att.name())].length() && String(att.name()) != XML_EVENT_ID) 
							data.appendChild(att);
				}
			}
			return data;
		}
		
		/**
		 * animate :: find the correct animating class to use and pass the relvant information over to that animation class.
		 * @param	target	<DisplayObject>	the target with which to apply the animation to.
		 * @param	event	<String>	a value to determin the requirement for the animation.
		 * @param	data	<XML>	the data pertaining to the animation, which will be transcribed from the animating Class.
		 * @return	<Boolean>	a true value if the animation was generated correctly or fasle if the animation failed in the generation.
		 */
		public static function animate(target:DisplayObject, event:String, data:XML):Boolean 
		{
			XML.prettyIndent			= 4;
			var object:AnimatorObject	= null;
			var item:XML				= null;
			var tmp:Boolean				= false;
			var rtn:Boolean				= false;
			checkAnimatorCompleteHandler();
			for each (object in _ANIMATORS) 
			{
				for each (item in data[XML_TWEEN_NODE]) 
				{
					if (String(item.@[XML_ANIMATOR_ATT]) == object.name && String(item.@[XML_EVENT_ID]) == event) 
						tmp	= object.animator.animateDisplayObject(target, item);
				}
				if (data[object.name].length()) 
				{
					for each (item in data[object.name]) 
						if (String(item.@[XML_EVENT_ID]) == event) 
							tmp	= object.animator.animateDisplayObject(target, item);
				}
				if (tmp) 
				{
					rtn	= tmp;
					_animations++;
				}
			}
			_animating	= rtn;
			return rtn;
		}
		
		protected static function checkAnimatorCompleteHandler():void 
		{
			var object:AnimatorObject	= null;
			for each (object in _ANIMATORS) 
			{
				if (!_listenedAnimators[object]) 
				{
					object.animator.addEventListener(AnimatorEvent.COMPLETE, animatorCompleteHandler);
					_listenedAnimators[object]	= true;
				}
			}
		}
		
		protected static function animatorCompleteHandler(event:AnimatorEvent):void 
		{
			_animations--;
			if (_animations == 0) 
			{
				_animating	= false;
				_dispatcher.dispatchEvent(new AnimatorEvent(AnimatorEvent.COMPLETE));
				_dispatcher.dispatchEvent(new AnimatorEvent(AnimatorEvent.PAGE_FINISHED));
			}
		}
		
		/**
		 * clear :: remove the animations placed upon a target or all aniamtions currently being animated.
		 * @param	target	<DisplayObject>	the target of which any animations placed upon to be stopped, this value can be left blank to stop and remove all animations curently being animated.
		 * @return	<Boolean>	true if the removal was successfull and false if no animation was stopped or removed.
		 */
		public static function clear(target:DisplayObject = null):Boolean 
		{
			var object:AnimatorObject	= null;
			var tmp:Boolean				= false;
			var rtn:Boolean				= false;
			for each (object in _ANIMATORS) 
			{
				tmp						= object.animator.clear(target);
				if (tmp) rtn			= tmp;
			}
			return rtn;
		}
		
		/**
		 * pause :: stop the current animations on all objects currently in operation if the displayObject is null otherwise stop all animations on the object passed, this method is a temporary pause in animation where the method 'resume' can be employed to start the animations from where they where stopped.
		 * 	this method will recurse through all available IAnimatiors and pause the animations with the target selected.
		 * @param	displayObject	<DisplayObject [default null]>	the object on which to stop the animations.
		 * @return	<Boolean>	a value to determin if any animatiosn where stopped or not.
		 */
		public static function pause(target:DisplayObject = null):Boolean 
		{
			var object:AnimatorObject	= null;
			var tmp:Boolean				= false;
			var rtn:Boolean				= false;
			for each (object in _ANIMATORS) 
			{
				tmp						= object.animator.pause(target);
				if (tmp) rtn			= tmp;
			}
			return rtn;
		}
		
		/**
		 * resume :: after the use of pause this method can be used to resume the effected animations from their previous tween point.
		 * 	this method will recurse through all available IAnimatiors and pause the animations with the target selected.
		 * @param	displayObject	<DisplayObject [default null]>	the object with which to resume the animation.
		 * @return	<Boolean>	a value to determine if there where any animations resumed or not.
		 */
		public static function resume(target:DisplayObject = null):Boolean 
		{
			var object:AnimatorObject	= null;
			var tmp:Boolean				= false;
			var rtn:Boolean				= false;
			for each (object in _ANIMATORS) 
			{
				tmp						= object.animator.resume(target);
				if (tmp) rtn			= tmp;
			}
			return rtn;
		}
		
		/**
		 * passAnimationXML :: when data is passed to the XMLAnimation Class that data may contain information regarding other IAnimator objects and thus any available will be instanced in the same way as normal DisplayObjects.
		 * @param	data	<XML>	the data containing the posible IAnimator classes.
		 */
		protected static function passAnimationXML(data:XML):void
		{
			if (!data[XML_I_ANIM].length()) return;
			var item:XML					= null;
			var $data:XMLList				= data[XML_I_ANIM].copy();
			var animators:Array				= null;
			var gObj:GraphicComponentObject	= null;
			for each (item in $data) item.setName(XMLGraphicDisplay.XML_GRAPHIC);
			item							= <data></data>;
			item.setChildren($data);
			if (!XMLGraphicDisplay.FACTORY.hasEventListener(GraphicFactoryEvent.COMPLETE)) 
				XMLGraphicDisplay.FACTORY.addEventListener(GraphicFactoryEvent.COMPLETE, graphicFactoryCompleteHandler);
			animators						= XMLGraphicDisplay.createGraphics(item);
			if (!_loadingAnimators) 
				_loadingAnimators			= new Array();
			for each (gObj in animators) 
			{
				if (XMLGraphicDisplay.checkAsLoader(gObj.graphic) && !XMLGraphicDisplay.checkLoaded(gObj.graphic)) 
					_loadingAnimators.push(gObj);
				else 
					_ANIMATORS.push(new AnimatorObject(String(gObj.data.@[XML_I_ANIM_QNAME]), gObj.graphic as IAnimator));
			}
			checkAnimatorCompleteHandler();
			if (!_loadingAnimators.length) 
				_loadingAnimators			= null;
		}
		
		/**
		 * graphicFactoryCompleteHandler :: handler for any files loading to generate the IAnimator's.
		 * @param	event	<GraphicFactoryEvent>	the event dispatched from the GraphicFactory instance generating the object.
		 */
		protected static function graphicFactoryCompleteHandler(event:GraphicFactoryEvent):void 
		{
			if (!_loadingAnimators) return;
			var gObj:GraphicComponentObject	= null;
			for each (gObj in _loadingAnimators) 
			{
				if (gObj && gObj.graphic == event.loader) 
				{
					_ANIMATORS.push(new AnimatorObject(String(gObj.data.@[XML_I_ANIM_QNAME]), gObj.graphic as IAnimator));
					gObj	= null;
				}
			}
			var count:int	= 0;
			for each (gObj in _loadingAnimators) if (!gObj) count++;
			if (count == _loadingAnimators.length) 
			{
				_loadingAnimators	= null;
				_dispatcher.dispatchEvent(new Event(Event.COMPLETE));
			}
			checkAnimatorCompleteHandler();
		}
		
	}
	
}