package
{
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	
	import mx.controls.Image;
	
    
	public class DinnerPlate extends Image
	{		
		public static const OUTER_RADIUS:int = 12;
		public static const INNER_RADIUS:int = 8;
		public static const RADII_MULT:Array = [0, .4, .6, .8, 1];
		public static const SIZE_NOT_THERE:int = 0;
		public static const SIZE_SMALL:int = 1;
		public static const SIZE_MED:int = 2;
		public static const SIZE_LG:int = 3;
		
		private var size:int = 0;
		
		private var outerPlate:Shape = new Shape();
		private var innerPlate:Shape = new Shape();
					
		public function DinnerPlate()
		{			
			this.width = OUTER_RADIUS * 2;
			this.height = OUTER_RADIUS * 2;
			
			redraw(0);
		}
		
		public function redraw(newSize:int):void {			
			/* if (size != 0) {
				removeChild(outerPlate);
				removeChild(innerPlate);
			} */
			
			/* if (newSize > 0) {	 */	
				innerPlate.graphics.clear();
				outerPlate.graphics.clear();
			
				outerPlate.graphics.beginFill(OUTER_PLATE_COLOR);
				outerPlate.graphics.lineStyle(1, 0x000000, 1, false, LineScaleMode.NONE);
				outerPlate.graphics.drawCircle(0, 0, OUTER_RADIUS * RADII_MULT[newSize]);
				outerPlate.graphics.endFill();
				addChild(outerPlate);
				
				innerPlate.graphics.beginFill(INNER_PLATE_COLOR);
				innerPlate.graphics.lineStyle(1, 0x000000, 1, false, LineScaleMode.NONE);
				innerPlate.graphics.drawCircle(0, 0, INNER_RADIUS * RADII_MULT[newSize]);
				innerPlate.graphics.endFill();
				addChild(innerPlate);
			/* } */
			
			size = newSize;
		}
		
		public static const OUTER_PLATE_COLOR:uint = 0xDDDDDD;
		public static const INNER_PLATE_COLOR:uint = 0xEEEEEE;
	}
}