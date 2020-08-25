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
package com.vesperopifex.xml 
{
	
	public class XMLStore 
	{
		protected var _system:XML		= <system></system>;
		protected var _preload:XML		= <preload></preload>;
		protected var _fonts:XML		= <fonts></fonts>;
		protected var _audio:XML		= <audio></audio>;
		protected var _pages:XML		= <pages></pages>;
		protected var _description:XML	= <description></description>;
		protected var _type:XML			= <type></type>;
		protected var _animation:XML	= <animation></animation>;
		protected var _data:XML			= null;
		
		/**
		 * @return	<XML>	data assigned to it in the format outlined while setting the data
		 */
		public function get data():XML { return _data; }
		
		/**
		 * @param	value	<XML>	data which can consist of any construct or formating of data.
		 * @throws	<ArgumentError>	data has already been assigned.
		 */
		public function set data(value:XML):void 
		{
			if (_data) throw new ArgumentError("Data has already been supplied and can not be overwriten.\ncreate a new instance and apply the required data to that instance.");
			else 
			{
				_data = value;
				if (_data.system) _system.setChildren(value.system.children().copy());
				if (_data.system.preload) _preload.setChildren(value.system.load.copy());
				if (_data.system.font) _fonts.setChildren(value.system.font.copy());
				if (_data.system.audio) _audio.setChildren(value.system.audio.copy());
				if (_data.page) _pages.setChildren(value.page.copy());
				if (_data.description) _description.setChildren(value.description.copy());
				if (_data.type) _type.setChildren(value.type.copy());
				if (_data.animation) _animation.setChildren(value.animation.children().copy());
			}
		}
		
		/**
		 * @return	<XML>	data assigned to it in the format outlined while setting the data
		 */
		public function get type():XML { return _type; }
		
		/**
		 * @return	<XML>	data assigned to it in the format outlined while setting the data
		 */
		public function get description():XML { return _description; }
		
		/**
		 * @return	<XML>	data assigned to it in the format outlined while setting the data
		 */
		public function get pages():XML { return _pages; }
		
		/**
		 * @return	<XML>	data assigned to it in the format outlined while setting the data
		 */
		public function get system():XML { return _system; }
		
		/**
		 * @return	<XML>	data assigned to it in the format outlined while setting the data
		 */
		public function get preload():XML { return _preload; }
		
		/**
		 * @return <XML>	data assigned to it in the format outlined while setting the data
		 */
		public function get animation():XML { return _animation; }
		
		/**
		 * @return <XML>	data assigned to it in the format outlined while setting the data
		 */
		public function get fonts():XML { return _fonts; }
		
		/**
		 * @return <XML>	data assigned to it in the format outlined while setting the data
		 */
		public function get audio():XML { return _audio; }
		
		/**
		 * Constructor
		 * @param	xml	<XML>	data assigned to it in the format outlined while setting the data
		 */
		public function XMLStore(xml:XML = null) 
		{
			if (xml) data = xml;
		}
		
	}
	
}