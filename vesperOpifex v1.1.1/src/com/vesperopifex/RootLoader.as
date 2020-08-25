package com.vesperopifex 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	// mxmlc com\vesperopifex\RootLoader.as -output ..\bin\content\swf\vesperopifex-loader.swf -sp . -use-network=false
	// mxmlc com/vesperopifex/RootLoader.as -output ../bin/content/swf/vesperopifex-loader.swf -sp . -use-network=false
	[SWF(width="900", height="550", backgroundColor="0xffffff", frameRate="30")]
	
	public class RootLoader extends Sprite 
	{
		public static const FLASHVAR_LOAD:String		= "framework";
		public static const DEFAULT_URL:String			= "vesperopifex.swf";
		
		[Embed(source='../../compiled-graphics.swf', symbol='PreloadingVisual')]
		private var preloadingVisual:Class;
		
		protected var loader:Loader						= new Loader();
		protected var request:URLRequest				= new URLRequest();
		protected var context:LoaderContext				= null;
		protected var flashVariables:Object				= null;
		protected var visual:MovieClip					= new preloadingVisual();
		protected var loadedClass:Object				= null;
		protected var loadedDisplayObject:DisplayObject	= null;
		
		/**
		 * Constructor.
		 */
		public function RootLoader() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * once the stage is available load the required SWF file onto the stage using the current ApplicationDomain.
		 * @param	event	<Event>	an event dispatched from the stage object.
		 */
		protected function init(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode	= StageScaleMode.NO_SCALE;
			flashVariables	= stage.loaderInfo.parameters;
			request.url		= (flashVariables[FLASHVAR_LOAD])? flashVariables[FLASHVAR_LOAD]: DEFAULT_URL;
			context			= new LoaderContext(false, ApplicationDomain.currentDomain);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadingProgressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadingCompleteHandler);
			addChild(visual);
			loader.load(request, context);
		}
		
		/**
		 * once the loading SWF file has completed downlaoding get the definition of the loaded class and instance that object onto the stage.
		 * @param	event	<Event>	an event dispatched from the contentLoaderInfo of the Loader class.
		 */
		protected function loadingCompleteHandler(event:Event):void 
		{
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadingProgressHandler);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadingCompleteHandler);
			removeChild(visual);
			loadedClass			= getDefinitionByName(getQualifiedClassName(loader.contentLoaderInfo.content));
			loadedDisplayObject	= new loadedClass() as DisplayObject;
			addChild(loadedDisplayObject);
			loader.unload();
			loader				= null;
			request				= null;
		}
		
		/**
		 * update the loading visual displayed on the stage determined by the amount of bytes loaded.
		 * @param	event	<ProgressEvent>	an event dispatched from the contentLoaderInfo of the Loader class.
		 */
		protected function loadingProgressHandler(event:ProgressEvent):void 
		{
			visual.gotoAndStop(int(visual.totalFrames * (event.bytesLoaded / event.bytesTotal)));
		}
		
	}
	
}