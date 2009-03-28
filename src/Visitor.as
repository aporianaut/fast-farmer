package
{
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.effects.Effect;
	import mx.effects.Move;
	import mx.effects.Parallel;
	import mx.effects.Rotate;
	
	public class Visitor extends Canvas
	{
		public static const VISITOR_BEFORE_VISITING:int = 0;
		public static const VISITOR_WAITING:int = 1;
		public static const VISITOR_TALKING:int = 2;
		public static const VISITOR_DANCING:int = 3;
		public static const VISITOR_EATING:int = 4;
		public static const VISITOR_AFTER_VISITING:int = 5;

		public static const BASE_VISIT_CHANCE:Number = .025;
		public static const NO_ONE_HOME_PENALTY:Number = .5;
		public static const INVITED_IN_BONUS:Number = 2;
		
		public static const POST_VISIT_WAIT:int = 2;
		public static const MIN_ACTIVITY_DUR:int = 3;
		
		public static const LOVE_FROM_DANCE:int = 10;
		public static const UNLOVE_FROM_NO_DANCE:int = 5;
		public static const LOVE_FROM_TALK:int = 5;
		public static const LOVE_FROM_WELCOME:int = 10;
		public static const UNLOVE_FROM_NOT_HOME:int = 5;
		public static const LOVE_FROM_EAT:int = 5;
/* 		public static const UNLOVE_FROM_MEAGER_FOOD:int = 3;
*/
		private static const PARTNER_NEARNESS:int = 100;	
		
		public static const VISITOR_WAYPOINTS:Array = [new Point(0, 320),
													   new Point(350, 375),
													   new Point(419, 375),
													   new Point(500, 325),
													   new Point(600, 450),
													   new Point(0, 500)];

		public static var MAX_DANCE:Number = 15;
		public static var PORTION_SIZE:Number = 1;

		public static var allVisitors:Array = [new Visitor(15, 0x0000ff, 8, [.2, .3, .2]),
											   new Visitor(20, 0x00bbbb, 6, [.2, .1, .4]),
											   new Visitor(18, 0xee00ee, 12, [.4, .2, .1]),
											   new Visitor(15, 0x0088ff, 8, [.15, .5, .25])];

		public static var partner:Visitor = null;

		private var stateTransitions:Array = [goAway, goDance, goEat, goTalk];
		
		private var patience:int;
		private var visitProbability:Number = BASE_VISIT_CHANCE;
		private var stateProbs:Array;
		private var _love:Number = 0;
		private var loveGlow: GlowFilter;
		
		
		public var waitedTime:int = 0;
		
		public var state:int = VISITOR_BEFORE_VISITING;

		public function Visitor(size:int, color:uint, patience:int, stateProbs:Array) // stateProbs = prob to leave, dance, eat in that order (talk % is remainder from 1)
		{
			this.width = this.height = size;
			this.setStyle("backgroundColor", color);
			
			this.patience = patience;
			this.stateProbs = stateProbs;
			
			this.visible = false;
			
			this.loveGlow = new GlowFilter(color, .3, 1, 1);
			filters=[loveGlow];
			
			var start:Point = VISITOR_WAYPOINTS[VISITOR_BEFORE_VISITING];
			this.move(start.x, start.y);
			
			
		}
		
		public function onTick(isHome:Boolean, tickCounter:int):void {
			if (this==partner) {
				onPartnerTick(tickCounter);
			}
			else {			
				waitedTime++;
				// Animate if necessary
				if ((waitedTime <= MIN_ACTIVITY_DUR) && (state == VISITOR_DANCING)) {
					dance();
				}
				// pulse if here, isHome, and even tick
				if (!(tickCounter % 4) && isHome && (visible == true)) {
					// TODO : effect that says I'm getting something out of hanging out with you
				}
				
				// Decide what to do next
				if (waitedTime > MIN_ACTIVITY_DUR) {
					if (state == VISITOR_BEFORE_VISITING) {
						//decide whether to visit
						if (Math.random() < visitProbability) {
							visible = true;
							state = VISITOR_WAITING;					
							animateTo(VISITOR_WAYPOINTS[VISITOR_WAITING]);
							waitedTime = 0;
						}
					}
					else if (state == VISITOR_WAITING) {
						if (waitedTime > patience) {
							state = VISITOR_AFTER_VISITING;			
							animateTo(VISITOR_WAYPOINTS[VISITOR_AFTER_VISITING]);
							visitProbability *= NO_ONE_HOME_PENALTY;
							love -= UNLOVE_FROM_NOT_HOME;					
							waitedTime = 0;
						}
						// come in if someone's at home
						if (isHome) {
							state = VISITOR_TALKING;
							animateTo(VISITOR_WAYPOINTS[VISITOR_TALKING]);
							visitProbability *= INVITED_IN_BONUS;
							waitedTime = 0;
							love += LOVE_FROM_WELCOME;
						}
					}
					else if (state == VISITOR_TALKING) {
						if (isHome) {
							love += LOVE_FROM_TALK;
						}
						rollStateTransition();
					}
					else if (state == VISITOR_DANCING) {
						if (isHome) {
							love += LOVE_FROM_DANCE;
						}
						else {
							love -= UNLOVE_FROM_NO_DANCE;
						}
						rollStateTransition();
					}
					else if (state == VISITOR_EATING) {
						love += LOVE_FROM_EAT;
						rollStateTransition();
					}
					else if (state == VISITOR_AFTER_VISITING) {
						visible = false;
						rotation = 0;	
						if (waitedTime > POST_VISIT_WAIT) {
							state = VISITOR_BEFORE_VISITING;
							waitedTime = 0;
							move(VISITOR_WAYPOINTS[VISITOR_BEFORE_VISITING].x, VISITOR_WAYPOINTS[VISITOR_BEFORE_VISITING].y);
						}
					}
				}
			}
		}
		
		private function onPartnerTick(tickCounter:int):void {
			// spin on half notes, waltz step around
			var effect:Effect = null;
			
			if (!(tickCounter % 12)) {
				var destination:Point = new Point(stage.mouseX + Math.random()*PARTNER_NEARNESS,
										          stage.mouseY + Math.random()*PARTNER_NEARNESS);
				/* var waypoint:Point = new Point((destination.x - x)/3 + x, (destination.y-y)/3 + y);	 */					          
										    				
				var m:Move = animateToWithDur(destination, FFConstants.TIME_PER_TICK * 4);
/* 				var m1:Move = animateToWithDur(waypoint, FFConstants.TIME_PER_TICK * 8);
 */				
				/* var m:Sequence = new Sequence();
				m.addChild(m1);
				m.addChild(m2); */
								       
				effect = m;
			}
			else if (!(tickCounter % 4)) {
				var r:Rotate = new Rotate();
				r.angleFrom = rotation;
				r.angleTo = rotation + randomRightAngle();
				r.duration = FFConstants.TIME_PER_TICK * 2;
				
				effect = r;
			}
			
			if (effect != null) {	
				effect.play([this]);
			}
			
		}
		
		private function randomRightAngle():int {
			var roll:Number = Math.random();
			if (roll < .5) {
				return -90;
			}
			else {
				return 90;
			}
		}
		
		// decide whether to eat, dance, or continue talking
		private function rollStateTransition():void {
			var i:int = 0;
			var roll:Number = Math.random();
			
			for (var acc:Number = 0; i < stateProbs.length; i++) {
				acc += stateProbs[i];
				if (acc > roll) {
					break;
				}
			}
			
			stateTransitions[i]();
			
			waitedTime = 0;
		}
		
		private function goAway():void {
			state = VISITOR_AFTER_VISITING;
			animateTo(VISITOR_WAYPOINTS[VISITOR_AFTER_VISITING]);
		}
		
		private function goDance():void {
			state = VISITOR_DANCING;
			if (state != VISITOR_DANCING) {
				animateTo(VISITOR_WAYPOINTS[VISITOR_DANCING]);
			}
			else dance();
		}
		
		private function goEat():void {
			state = VISITOR_EATING;
			animateTo(VISITOR_WAYPOINTS[VISITOR_EATING]);
			HomeRegionCanvas.theHome.storedFood -= PORTION_SIZE;
		}
		
		private function goTalk():void {
			state = VISITOR_TALKING;
			animateTo(VISITOR_WAYPOINTS[VISITOR_TALKING]);			
		}
		
		public function animateTo(p:Point):void {
			animateToWithDur(p, 2*FFConstants.TIME_PER_TICK).play([this]);
		}
		
		public function animateToWithDur(p:Point, duration:int):Move {
			var m:Move = new Move();
			m.xTo = p.x;
			m.yTo = p.y;
			m.duration = duration; 
			
			return m;
		}
		
		public function dance():void {
			var m:Move = new Move(this);
			var p:Point = VISITOR_WAYPOINTS[VISITOR_DANCING];
			
			m.xTo = p.x + (Math.random() * 2 * MAX_DANCE) - MAX_DANCE;
			m.yTo = p.y + (Math.random() * 2 * MAX_DANCE) - MAX_DANCE;
			m.duration = FFConstants.TIME_PER_TICK;
			
			
			var r:Rotate = new Rotate(this);
			r.angleTo = this.rotation + 90;
			r.duration = FFConstants.TIME_PER_TICK;
			
			var combined:Parallel = new Parallel(this);
			combined.children = [m, r];
			combined.play(); 
		}
		
		public function set love(newLove:Number):void {
			if (newLove > _love) {
				HomeRegionCanvas.lovePulse(0xffffff);
			}
			else if (newLove < _love) {
				HomeRegionCanvas.lovePulse(0x000000);
			}
			
			_love = newLove;
			if (_love > 100) {
				_love = 100;
				if (partner == null) {
					partner = this;
				}
			}
			if (_love < 0) _love = 0;
			loveGlow.blurX = loveGlow.blurY = _love / 5;
			filters=[loveGlow];
		}
		
		public function get love():Number {
			return _love;
		}
		
		public static function numOfFuneralVisitors():int {
			var totalLove:int = 0;
			for each (var v:Visitor in allVisitors) {
				totalLove += v.love;
			}
			
			return totalLove / 10;
		}
		
		public static function newFuneralVisitor():Visitor {
			var v:Visitor = new Visitor(8 + Math.random() * 17, Math.random() * 0xffffff, 0, [0,0,0]);
			v.move(-5, 235 + Math.random() * 265);
			v.visible=true;
			
			var m:Move = new Move();
			m.xFrom = -5;
			m.yFrom = v.y;
			m.xTo = 390 + Math.random() * 325;
			m.yTo = 265 + Math.random() * 235;
			m.duration = FFConstants.TIME_PER_TICK * 2;
			m.play([v]);
			
			return v;
		}
	}
}