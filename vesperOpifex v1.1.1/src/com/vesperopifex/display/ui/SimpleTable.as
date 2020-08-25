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
package com.vesperopifex.display.ui 
{
	import com.vesperopifex.display.GraphicComponentObject;
	import com.vesperopifex.display.GraphicFactory;
	import com.vesperopifex.display.SimpleInformationPanel;
	import com.vesperopifex.events.GraphicEvent;
	import com.vesperopifex.events.SimpleTableEvent;
	import com.vesperopifex.events.StyleSheetFactoryEvent;
	import com.vesperopifex.utils.XMLGraphicDisplay;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	
	public class SimpleTable extends SimpleInformationPanel 
	{
		public static const XML_NODE:String				= "table";
		
		public static var REGISTERED:Boolean			= GraphicFactory.registerGenerator(XML_NODE, generateTable);
		
		protected var _columns:int						= int.MAX_VALUE;
		protected var _rows:int							= 1;
		protected var _width:Number						= NaN;
		protected var _height:Number					= NaN;
		protected var _colWidth:Number					= NaN;
		protected var _rowHeight:Number					= NaN;
		protected var _positionedX:Array				= new Array();
		protected var _positionedY:Array				= new Array();
		protected var _cellsPadding:Padding				= null;
		protected var _cell_padding:Number				= NaN;
		protected var _cell_padding_horizontal:Number	= NaN;
		protected var _cell_padding_vertical:Number		= NaN;
		protected var _cells:Array						= new Array();
		protected var _cellMatrix:Array					= new Array();
		protected var _graphicCompleteCount:int			= 0;
		
		public function get columns():int { return _columns; }
		public function set columns(value:int):void 
		{
			_columns = value;
			if (_rows == 1 && _columns == 1) 
				_rows		= int.MAX_VALUE;
		}
		
		public function get rows():int { return _rows; }
		public function set rows(value:int):void 
		{
			_rows = value;
			if (_columns == int.MAX_VALUE && _rows != 1) 
				_columns	= 1;
		}
		
		public override function set width(value:Number):void 
		{
			_width = value;
			setRowsWidth();
		}
		
		public override function set height(value:Number):void 
		{
			_height = value;
			setColumnsHeight()
		}
		
		public function set padding(value:Number):void 
		{
			_cell_padding = value;
		}
		
		public function set cell_padding(value:Number):void 
		{
			_cell_padding = value;
		}
		
		public function set cell_padding_horizontal(value:Number):void 
		{
			_cell_padding_horizontal = value;
		}
		
		public function set padding_h(value:Number):void 
		{
			_cell_padding_horizontal = value;
		}
		
		public function set cell_padding_vertical(value:Number):void 
		{
			_cell_padding_vertical = value;
		}
		
		public function set padding_v(value:Number):void 
		{
			_cell_padding_vertical = value;
		}
		
		/**
		 * Generate itself for implementation into the GraphicFactory generator, for on the fly creation without the requirement to be hand coded into the GraphicFactory Class.
		 * @param	data	<XML>	the data pertaining to the generation of the Class.
		 * @return	<DisplayObject>	the resulting object to be passed back for further actioning.
		 */
		public static function generateTable(data:XML):DisplayObject 
		{
			return new SimpleTable() as DisplayObject;
		}
		
		/**
		 * SimpleTable :: Constructor.
		 */
		public function SimpleTable() 
		{
			super();
		}
		
		/**
		 * create the graphics for this object.
		 */
		protected override function generateGraphics():void
		{
			if (_rows == 1 && _columns == int.MAX_VALUE) _columns	= XMLGraphicDisplay.countGraphicChildren(_data);
			super.generateGraphics();
		}
		
		/**
		 * add all the finishing parts to the generated graphics.
		 */
		protected override function finishedGraphicGeneration():void 
		{
			assignCells();
			applyGraphicDetails();
			applyContextEvents();
			applyMaskSprites();
			removeLoaderVisual();
		}
		
		/**
		 * run through all graphics and determin if a SimpleCell is required to be generated for a single graphic or to directly add the SimpleCell to the Array.
		 */
		protected function assignCells():void 
		{
			var object:GraphicComponentObject	= null;
			var cell:SimpleCell					= null;
			for each (object in _children) 
			{
				if (!object.graphic) continue;
				if (object.graphic is SimpleCell) 
				{
					cell	= object.graphic as SimpleCell;
					cell.addEventListener(GraphicEvent.COMPLETE, cellsCompleteHandler);
					_cells.push(cell);
				} else 
				{
					cell	= SimpleCell.generateCell(object.data) as SimpleCell;
					cell.addEventListener(GraphicEvent.COMPLETE, cellsCompleteHandler);
					cell.addGraphic(object);
					_cells.push(cell);
				}
				addChild(cell);
			}
			passAvailableDetailsToCells();
		}
		
		/**
		 * if there are any additional attributes on the table XML then pass them along to the cells.
		 */
		protected function passAvailableDetailsToCells():void 
		{
			var cell:SimpleCell	= null;
			var item:XML		= null;
			var name:String		= null;
			for each (cell in _cells) 
			{
				for each (item in _data.attributes()) 
				{
					name		= String(item.name());
					if (name == "stretch" || name == "align") 
						cell[name]	= String(item);
					if (name == "rounded" || name == "backgroundAlpha" || name == "borderAlpha" || name == "borderWidth") 
						cell[name]	= Number(item);
					if (name == "backgroundColor" || name == "borderColor") 
						cell[name]	= uint(item);
					if (name == "background" || name == "border" || name == "relativePosition") 
						cell[name]	= (String(item) == "true")? true: false;
				}
			}
		}
		
		/**
		 * handler for when each SimpleCell has all their grahpics completed.
		 * @param	event
		 */
		protected function cellsCompleteHandler(event:GraphicEvent):void 
		{
			if ((event.target as IEventDispatcher).hasEventListener(GraphicEvent.COMPLETE)) 
				(event.target as IEventDispatcher).removeEventListener(GraphicEvent.COMPLETE, cellsCompleteHandler);
			if (!(event.target as IEventDispatcher).hasEventListener(SimpleTableEvent.CELL_UPDATE)) 
				(event.target as IEventDispatcher).addEventListener(SimpleTableEvent.CELL_UPDATE, cellUpdateHandler);
			if (event.cancelable) event.stopImmediatePropagation();
		}
		
		/**
		 * addGraphicChildren :: add the generated graphics and add them to the stage according the their appearance in the XML.
		 */
		protected override function addGraphicChildren(object:GraphicComponentObject = null):void 
		{
			for each (var cell:SimpleCell in _cells) addChild(cell);
			if (hasEventListener(GraphicEvent.COMPLETE)) dispatchEvent(new GraphicEvent(GraphicEvent.COMPLETE));
		}
		
		/**
		 * handler for the arrangement of cells within the table to update the display and positioning of all cells.
		 * @param	event	<SimpleTableEvent>	the dispatched event from the cell updated.
		 */
		protected function cellUpdateHandler(event:SimpleTableEvent = null):void 
		{
			if (event && event.cancelable) event.stopImmediatePropagation();
			updateCellMatrix();
			updateCellPositions();
		}
		
		protected function findCellPadding():void 
		{
			var paddLeft:Number		= 0;
			var paddTop:Number		= 0;
			var paddRight:Number	= 0;
			var paddBottom:Number	= 0;
			if (_cell_padding) 
			{
				if (_cell_padding_horizontal) 
					paddLeft	= paddRight		= _cell_padding_horizontal / 2;
				else 
					paddLeft	= paddRight		= _cell_padding / 2;
				if (_cell_padding_vertical) 
					paddTop		= paddBottom	= _cell_padding_vertical / 2;
				else 
					paddTop		= paddBottom	= _cell_padding / 2;
			} else 
			{
				if (_cell_padding_horizontal) 
					paddLeft	= paddRight		= _cell_padding_horizontal / 2;
				if (_cell_padding_vertical) 
					paddTop		= paddBottom	= _cell_padding_vertical / 2;
			}
			_cellsPadding			= new Padding(paddTop, paddLeft, paddRight, paddBottom);
		}
		
		protected function findCellWidthHeight():void 
		{
			_colWidth	= (_width)? _width / _columns: NaN;
			_rowHeight	= (_height)? _height / _rows: NaN;
		}
		
		protected function positionColumn(index:int, posX:Number):void 
		{
			var cell:SimpleCell	= null;
			var j:int			= 0;
			rowLoop: for (var i:int = 0; i < _cellMatrix.length; i++) 
			{
				cell	= _cellMatrix[i][index];
				if (!cell) continue;
				for (j = 0; i < _positionedX.length; i++) 
					if (_positionedX[j] == cell) 
						continue rowLoop;
				_positionedX.push(cell);
				cell.x	= posX;
			}
		}
		
		protected function positionRow(index:int, posY:Number):void 
		{
			var row:Array		= _cellMatrix[index];
			var cell:SimpleCell	= null;
			var j:int			= 0;
			rowLoop: for (var i:int = 0; i < row.length; i++) 
			{
				cell	= row[i];
				if (!cell) continue;
				for (j = 0; i < _positionedY.length; i++) 
					if (_positionedY[j] == cell) 
						continue rowLoop;
				_positionedY.push(cell);
				cell.y	= posY;
			}
		}
		
		/**
		 * pass all cells and arrange them in accordance to the properties specified by the rows and columns and in accordance to the spanning of each cell.
		 */
		protected function updateCellPositions():void
		{
			findCellPadding();
			findCellWidthHeight();
			_positionedY		= new Array();
			var currentX:Number	= _cellsPadding.left;
			var currentY:Number	= _cellsPadding.top;
			for (var i:int = 0; i < _rows; i++) 
			{
				positionRow(i, currentY);
				currentY	+= findRowHeight(i);
			}
			for (i = 0; i < _columns; i++) 
			{
				positionColumn(i, currentX);
				currentX	+= findColumnWidth(i);
			}
		}
		
		/**
		 * find the row requested and return the highest height available, if the value passed is larger than the number of rows available then NaN is returned.
		 * @param	value	<int>	the index of the row to search for.
		 * @return	<Number>	the maximum height of the row.
		 */
		protected function findRowHeight(value:int):Number 
		{
			if (value >= _cellMatrix.length) return NaN;
			var cell:SimpleCell		= null;
			var i:int				= 0;
			var rtn:Number			= 0;
			for (i = 0; i < (_cellMatrix[value] as Array).length; i++) 
			{
				cell	= _cellMatrix[value][i] as SimpleCell;
				if (cell && cell.spanRows == 1 && cell.height > rtn) rtn	= cell.height;
			}
			if (rtn == 0 && cell && cell.spanRows > 1) 
				rtn	=	cell.height / cell.spanRows;
			if (_cellsPadding) 
				rtn	+= _cellsPadding.top + _cellsPadding.bottom;
			return rtn;
		}
		
		/**
		 * find the column requested and return the highest width available, if the value passed is larger than the number of columns available then NaN is returned.
		 * @param	value	<int>	the index of the column to search for.
		 * @return	<Number>	the maximum width of the row.
		 */
		protected function findColumnWidth(value:int):Number 
		{
			if (value >= (_cellMatrix[0] as Array).length) return NaN;
			var cell:SimpleCell		= null;
			var i:int				= 0;
			var rtn:Number			= 0;
			for (i; i < _cellMatrix.length; i++) 
			{
				cell	= _cellMatrix[i][value] as SimpleCell;
				//trace(cell.width);
				if (cell && cell.spanColumns == 1 && cell.width > rtn) rtn	= cell.width;
			}
			if (rtn == 0 && cell && cell.spanColumns > 1) 
				rtn	=	cell.width / cell.spanColumns;
			if (_cellsPadding) 
				rtn	+= _cellsPadding.left + _cellsPadding.right;
			return rtn;
		}
		
		/**
		 * set the width of all the cells in proportion to the current width of the table, every cell is scaled in a ratio to the new table width.
		 */
		protected function setRowsWidth():void
		{
			var cellWidth:Number	= NaN;
			var tableWidth:Number	= NaN;
			var currWidth:Number	= width;
			var cols:Number			= NaN;
			var padH:Number			= 0;
			var row:Array			= null;
			var cell:SimpleCell		= null;
			var i:int				= 0;
			var j:int				= 0;
			if (_cell_padding) 
				padH				= _cell_padding / 2;
			if (_cell_padding_horizontal) 
				padH				= _cell_padding_horizontal / 2;
			for (i; i < _cellMatrix.length; i++) 
			{
				row					= _cellMatrix[i] as Array;
				if (!cols) 
				{
					cols			= (row.length < _columns)? row.length: _columns;
					tableWidth		= _width - (padH * cols);
				}
				for (j; j < row.length; j++) 
				{
					cell			= row[j] as SimpleCell;
					cellWidth		= ((cell.width + padH) / (currWidth + padH)) * tableWidth;
					cell.width		= cellWidth;
				}
			}
		}
		
		/**
		 * set the height of all the cells in proportion to the current height of the table, every cell is scaled in a ratio to the new table height.
		 */
		protected function setColumnsHeight():void
		{
			var cellHeight:Number	= NaN;
			var tableHeight:Number	= NaN;
			var currHeight:Number	= height;
			var rows:Number			= (_cellMatrix.length < _rows)? _cellMatrix.length: _rows;
			var padV:Number			= 0;
			var row:Array			= null;
			var cell:SimpleCell		= null;
			var i:int				= 0;
			var j:int				= 0;
			if (_cell_padding) 
				padV				= _cell_padding / 2;
			if (_cell_padding_vertical) 
				padV				= _cell_padding_vertical / 2;
			tableHeight				= _height - (padV * rows);
			for (i; i < _cellMatrix.length; i++) 
			{
				row					= _cellMatrix[i] as Array;
				for (j; j < row.length; j++) 
				{
					cell			= row[j] as SimpleCell;
					cellHeight		= ((cell.height + padV) / (currHeight + padV)) * tableHeight;
					cell.height		= cellHeight;
				}
			}
		}
		
		/**
		 * organise all cells into a 2 layer Array, _cellMatrix.
		 */
		protected function updateCellMatrix():void
		{
			_cellMatrix				= configureMatrix();
			for each (var cell:SimpleCell in _cells)  
				assignCell(cell);
		}
		
		/**
		* apply the required dimensions of the Array to handle the rows and columns of the table.
		*/
		protected function configureMatrix():Array 
		{
			var rtn:Array	= new Array(_rows);
			for (var i:int = 0; i < rtn.length; i++) 
				rtn[i]		= new Array(_columns);
			return rtn;
		}
		
		/**
		* pass through the available Array space and determine if an object can be placed in the table.
		*/
		protected function assignCell(cell:SimpleCell):void 
		{
			var j:int				= 0;
			var row:Array			= null;
			var tCell:SimpleCell	= null;
			rowLoop: for (var i:int = 0; i < _rows; i++) 
			{
				row					= _cellMatrix[i];
				for (j = 0; j < _columns; j++) 
				{
					tCell			= row[j];
					if (tCell) 
					{
						if (tCell == cell && cell.spanRows > 1) assignSpanRows(cell, i, j);
						continue;
					}
					if (cell.spanColumns > 1) assignSpanColumns(cell, row, j);
					if (cell.spanRows > 1) assignSpanRows(cell, i, j);
					row[j]			= cell;
					break rowLoop;
				}
			}
		}
		
		/**
		* pass through the spanning variable of the SimpleCell and assign the available space for that object.
		*/
		protected function assignSpanColumns(cell:SimpleCell, row:Array, index:int):void 
		{
			for (var i:int = index; i < cell.spanColumns; i++) 
			{
				if (i >= _columns || row[i]) return;
				row[i]	= cell;
			}
		}
		
		/**
		* pass through the spanning variable of the SimpleCell and assign the available space for that object.
		*/
		protected function assignSpanRows(cell:SimpleCell, rowIndex:int, columnIndex:int):void 
		{
			for (var i:int = rowIndex; i < cell.spanRows; i++) 
			{
				if (i >= _rows || _cellMatrix[i][columnIndex]) return;
				_cellMatrix[i][columnIndex]	= cell;
			}
		}
		
	}
	
}

class Padding extends Object 
{
	private var _bottom:Number	= NaN;
	private var _left:Number	= NaN;
	private var _right:Number	= NaN;
	private var _top:Number		= NaN;
	
	public function get bottom():Number { return _bottom; }
	
	public function get left():Number { return _left; }
	
	public function get right():Number { return _right; }
	
	public function get top():Number { return _top; }
	
	public function Padding(top:Number = 0, left:Number = 0, right:Number = 0, bottom:Number = 0) 
	{
		_top	= top;
		_left	= left;
		_right	= right;
		_bottom	= bottom;
	}
	
}