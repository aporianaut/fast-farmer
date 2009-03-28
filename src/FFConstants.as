package
{
	import flash.geom.Point;
		
	public class FFConstants
	{
		public static const TIME_PER_TICK:int = 250;
		public static const NEAR_TIME_PER_TICK:int = 240;
	
		public static const SEASON_SPRING:int = 0;
		public static const SEASON_SUMMER:int = 1;
		public static const SEASON_FALL:int = 2;
		public static const SEASON_WINTER:int = 3;
		
/* 		public static const AREA_NONE:int = 100;
		public static const AREA_FIELDS:int = 101;
		public static const AREA_BUILDINGS:int = 102;
		public static const AREA_HOME:int = 103; */
		
		public static const WINTER_COLOR:uint = 0xC5D5DA;
		public static const SPRING_COLOR:uint = 0x99C143;
		public static const SUMMER_COLOR:uint = 0xFEDB37;
		public static const FALL_COLOR:uint = 0xE28E17;
		
		public static const STARTING_FOOD:Number = 5;
		public static const SMALL_FOOD_BENEFIT:Number = .0625;
		public static const LARGE_FOOD_BENEFIT:Number = .125;
		
		public static const BUILDING_COSTS:Array = [12.0, 30.0, 55.0, 90.0, 140.0];
		public static const BUILDING_UPGRADE_BENEFIT:Array = [1, 2, 4, 8, 16, 32];
		public static const SEASONAL_BUILDING_DECAY:Array = [0,0,0,0];//[.25, .25, .25, .5];
		
		public static const BUILDING_CAPACITIES:Array = [32, 64, 128, 256];
		
		public static const SPEED_THRESHOLDS:Array = [5, 15, 42, 60, 66]; // in seasons
		public static const TICKS_PER_SEASON_AT_STAGE:Array = [16, 8, 4, 2, 2, 2];
		public static const ADULT_SEASON:int = SPEED_THRESHOLDS[0];
		public static const OLD_SEASON:int = SPEED_THRESHOLDS[2]
		public static const END_SEASON:int = SPEED_THRESHOLDS[3];	
	
	}
}