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
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	
	public class LoadContext extends Object 
	{
		/**
		 * LoadContext :: Constructor
		 */
		public function LoadContext() 
		{
			
		}
		
		/**
		 * createContext :: generate a LoaderContext depending on the XML data passed
		 * @param	data	<XML>
		 * @return	<LoaderContext>
		 */
		public static function create(data:XML):LoaderContext 
		{
			var chkPol:Boolean = false;
			var AppDom:ApplicationDomain = null;
			var SecDom:SecurityDomain = null;
			var LodCon:LoaderContext = null;
			
			if (data.@*.length() > 0) 
			{
				LodCon = new LoaderContext();
				if (data.@checkPolicyFile) 
				{
					LodCon.checkPolicyFile = Boolean(data.@checkPolicyFile.toString());
					if (data.@applicationDomain) 
					{
						LodCon.applicationDomain = (data.@applicationDomain.toString() == "current")? 
														ApplicationDomain.currentDomain: 
														ApplicationDomain.currentDomain.parentDomain;
						if (data.@securityDomain && checkSecurityDomain(Security.sandboxType)) 
						{
							LodCon.securityDomain = (data.@securityDomain.toString() == "current")? 
														SecurityDomain.currentDomain: 
														null;
						}
					}
				}
			} else if (data.children().length() > 0) 
			{
				LodCon = new LoaderContext();
				if (data.checkPolicyFile) 
				{
					LodCon.checkPolicyFile = Boolean(data.checkPolicyFile.toString())
					if (data.applicationDomain) 
					{
						LodCon.applicationDomain = (data.applicationDomain.toString() == "current")? 
														ApplicationDomain.currentDomain: 
														ApplicationDomain.currentDomain.parentDomain;
						if (data.securityDomain && checkSecurityDomain(Security.sandboxType)) 
						{
							LodCon.securityDomain = (data.securityDomain.toString() == "current")? 
														SecurityDomain.currentDomain: 
														null;
						}
					}
				}
			}
			
			return LodCon;
		}
		
		public static function checkSecurityDomain(value:String):Boolean 
		{
			switch (value) 
			{
				case Security.LOCAL_TRUSTED:
					return false;
					break;
				case Security.LOCAL_WITH_FILE:
					return false;
					break;
				case Security.LOCAL_WITH_NETWORK:
					return false;
					break;
				case Security.REMOTE:
					return true;
					break;
			}
			
			return false;
		}
		
	}
	
}