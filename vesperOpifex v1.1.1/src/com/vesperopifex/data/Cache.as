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
package com.vesperopifex.data 
{
	
	public class Cache extends Object 
	{
		protected static var _dataArray:Array = new Array();
		
		/**
		 * Cache :: Constructor
		 */
		public function Cache() 
		{
			
		}
		
		/**
		 * search :: return a Boolean object to determin if there is an object in the cache with the identification String passed to the method.
		 * @param	id	<String>	the identification of the object to search for.
		 * @return	<Boolean>	the value of whether the object is in the cache, true, or not, false.
		 */
		public function search(id:String):Boolean 
		{
			var rtn:Boolean = false;
			for each (var obj:CacheObject in _dataArray) 
			{
				if (obj.id == id) 
				{
					rtn = true;
					break;
				}
			}
			return rtn;
		}
		
		/**
		 * add :: add an object to the cache with an identification String object for later retrival.
		 * @param	id	<String>	the identification object for the stored * (unknown type) object.
		 * @param	data	<* [unknown]>	any form of data can be stored in the cache for later reteieval.
		 * @param	... params	<* [unknown]>	any further paramaters to be stored with the cached object.
		 * @return	<Boolean>	determination of whether the object was placed in the cache (true) or not (false).
		 */
		public function add(id:String, data:*, ... params):Boolean 
		{
			var rtn:Boolean = search(id);
			if (!rtn) rtn = Boolean(_dataArray.push(new CacheObject(id, data, params)));
			return rtn;
		}
		
		/**
		 * retrieve :: return an available object which is identified by the Strign paramater passed into the method.
		 * @param	id	<String>	the identifyer of the object to retrieve.
		 * @return	<CacheObject>	a generic object for storage in the cache.
		 */
		public function retrieve(id:String):CacheObject 
		{
			if (_dataArray.length) 
			{
				var rtn:CacheObject;
				for each (var arr:CacheObject in _dataArray) 
				{
					if (arr.id == id) rtn = arr;
				}
				return rtn;
			} else return null;
		}
		
		/**
		 * length :: the total number of objects in the cache.
		 * @return	<uint>	the number of objects in the cache.
		 */
		public function length():uint 
		{
			return _dataArray.length;
		}
		
		/**
		 * remove :: removean object fromt he cache, clearing memory and space for further actioning, this can be used well if the requirements of the applicaiton are image heavy, removign any unrequired assets (XML data and other forms of download) can release more memory to the system.
		 * @param	id	<String>	the identifier of the object placed in the cache.
		 * @return	<CacheObject>	the object removed from the cache.  To truley delete this object, do not assign it to a value and run the garbage collection afterwards.
		 */
		protected function remove(id:String):CacheObject 
		{
			var rtn:CacheObject;
			for (var i:int = 0; i < _dataArray.length; i++) 
				if (_dataArray[i].id == id) rtn = _dataArray.splice(i, 1);
			return rtn;
		}
	}
	
}