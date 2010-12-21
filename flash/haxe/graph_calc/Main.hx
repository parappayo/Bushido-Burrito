
import flash.events.Event;

class Main
{
	static var calc :GraphCalc;
	static var formulaEntry :FormulaEntry;
	static var formulaTokenizer :FormulaTokenizer;
	static var formulaParser :FormulaParser;

	static function main()
	{
		calc = new GraphCalc();
		flash.Lib.current.addChild(calc);

		calc.canvasWidth = 1280;
		calc.canvasHeight = 720;
		calc.frontColor = 0xffffff;
		calc.backColor = 0x000000;

		formulaEntry = new FormulaEntry();
		flash.Lib.current.addChild(formulaEntry);
		formulaEntry.addEventListener(
			FormulaEntry.ENTRY_DONE,
			onFormulaEntryDone);

		formulaTokenizer = new FormulaTokenizer();
		formulaParser = new FormulaParser();

		//showFormulaEntry();

		// until formula entry UI is done, do this instead
		calc.plot( Math.sin, 0, 5 );
		showGraphCalc();
	}

	static function showFormulaEntry()
	{
		calc.visible = false;
		formulaEntry.visible = true;
	}

	static function showGraphCalc()
	{
		calc.visible = true;
		formulaEntry.visible = false;
	}

	static function onFormulaEntryDone(e :Event)
	{
		// TODO: parse and plot the function actually entered
		calc.plot( Math.sin, 0, 5 );

		showGraphCalc();
	}
}

