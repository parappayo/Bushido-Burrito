
import flash.events.Event;

class Main
{
	static var calc :GraphCalc;

	static function main()
	{
		calc = new GraphCalc();
		flash.Lib.current.addChild(calc);
		calc.canvasWidth = 1280;
		calc.canvasHeight = 720;
		calc.frontColor = 0xffffff;
		calc.backColor = 0x000000;

		calc.plot( Math.sin, 0, 5 );
	}
}

