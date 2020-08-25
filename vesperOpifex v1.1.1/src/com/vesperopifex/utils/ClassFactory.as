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
package com.vesperopifex.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class ClassFactory extends Object 
	{
		public static const CLASS_DELIMINATOR:String	= "::";
		
		/**
		 * ClassFactory :: Constructor.
		 */
		public function ClassFactory() 
		{
			super();
		}
		
		/**
		 * pass any object to find the Class definition for that object, if the object passed is a String then that string object will be directly used to find the definition otherwise the object wil be questioned to find its fully qualified name and the returning value will be the Class definition.
		 * @param	object	<*>	any object can be passed to find the Class definition, String objects are delt with differently.
		 * @return	<Object>	the definition of teh object passed.
		 */
		public static function getClassDefinition(object:*):Object	
		{
			if (object is String) return getDefinitionByName(String(object));
			return getDefinitionByName(getDefinitionClassName(object));
		}
		
		/**
		 * using flash.utils.getQualifiedClassName return the name of the object passed regardless of where the object has been loaded from.
		 * @param	object	<*>	any object can be passed to find the definition of the available object.
		 * @return	<String>	the qualified name of the object passed.
		 */
		public static function getDefinitionClassName(object:*):String 
		{
			return getQualifiedClassName(object);
		}
		
		/**
		 * returns the Class definition assosiated with the passed qualifiedClassName.
		 * @param	qualifiedClassName	<String>	the full qualified class name of the rewuired Class object.
		 * @param	loader	<AbstractLoader>	the loaded file containing the required Class.
		 * @return	<Object>
		 */
		public function getChildDomainDefinition(className:String, loader:AbstractLoader):Object 
		{
			return loader.contentLoaderInfo.applicationDomain.getDefinition(className);
		}
		
		/**
		 * find the defined class in the passed library and return as a Class.
		 * @param	className	<String>	the qualified class name found on the library Class.
		 * @param	library	<Object>	class loaded from another swf file which lists the available Class(s) within the ApplicationDomain.
		 * @return	<Class>
		 */
		public function getChildDomainLibraryDefinition(className:String, library:Object):Class 
		{
			return library[className] as Class;
		}
		
		/**
		 * retrieveAsDisplayObjectContainer :: generate and return the class pertaining to the current ApplicationDomain or a child SWF files ApplicationDomain, through either the use of a library class or available directly, if successful then a DisplayObjectContainer is returned otherwise null.
		 * @param	className	<String>	required class description.
		 * @param	loader	<AbstractLoader>	container of a child ApplicationDomain where resources are available.
		 * @param	libraryName	<String>	if the use of a library class is required pass this value as the qualified name of the Class pertaining to the library on another ApplicationDomain.
		 * @return	<DisplayObjectContainer>
		 */
		public function retrieveAsDisplayObjectContainer(	className:String, 
															loader:AbstractLoader = null, 
															libraryName:String = null):DisplayObjectContainer 
		{
			return retrieveAsDisplayObject(className, loader, libraryName) as DisplayObjectContainer;
		}
		
		/**
		 * retrieveAsDisplayObject :: generate and return the class pertaining to the current ApplicationDomain or a child SWF files ApplicationDomain, through either the use of a library class or available directly, if successful then a DisplayObject is returned otherwise null.
		 * @param	className	<String>	required class description.
		 * @param	loader	<AbstractLoader>	container of a child ApplicationDomain where resources are available.
		 * @param	libraryName	<String>	if the use of a library class is required pass this value as the qualified name of the Class pertaining to the library on another ApplicationDomain.
		 * @return	<DisplayObject>
		 */
		public function retrieveAsDisplayObject(	className:String, 
													loader:AbstractLoader = null, 
													libraryName:String = null):DisplayObject 
		{
			var object:Object		= retrieveAsClassObject(className, loader, libraryName);
			if (!object) 
			{
				if (libraryName && !loader) 
				{
					object	= retrieveAsClassObject(libraryName);
					return new (new object()[className])() as DisplayObject;
				} else return null;
			}
			return new object() as DisplayObject;
		}
		
		/**
		 * will try and find the passed className on the current ApplicationDomain if no other paramaters are passed, if only the loader and not the libraryName is passed the childs ApplicationDomain will be checked for className, otherwise if the libraryName is passed with a loader then a library will be instanced and the className will be searched upon that library Class.
		 * Anything retrieved from the current or child ApplicationDomain will be returned.
		 * @param	className	<String>	required class description.
		 * @param	loader	<AbstractLoader>	container of a child ApplicationDomain where resources are available.
		 * @param	libraryName	<String>	if the use of a library class is required pass this value as the qualified name of the Class pertaining to the library on another ApplicationDomain.
		 * @return	<Class>
		 */
		public function retrieveAsClassObject(	className:String, 
												loader:AbstractLoader = null, 
												libraryName:String = null):Class 
		{
			var rtn:Class	= null;
			var lib:Object	= null;
			if (!loader) 
			{
				try 
				{
					rtn = getDefinitionByName(className) as Class;
				} catch (error:Error) 
				{
					return null;
				}
			}
			if (loader && !rtn) 
			{
				lib		= getChildDomainDefinition((libraryName)? libraryName: className, loader);
				if (libraryName && lib) 
					rtn	= getChildDomainLibraryDefinition(className, new lib());
				else 
					rtn	= lib as Class;
			}
			return rtn;
		}
		
	}
	
}