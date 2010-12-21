/*
 *  FormulaEntry.hx
 *
 *  User interface for inputting the formula to plot.
 */

import flash.display.Sprite;

import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import flash.events.Event;

class FormulaEntry extends Sprite
{
	public static var ENTRY_DONE = "entryDone";

	private var inputTextField :TextField;
	private var acceptButton :Button;

	public function new()
	{
		super();

		var textFormat :TextFormat = new TextFormat();
		//textFormat.font = "arial";
		//textFormat.size = 12;

		inputTextField = new TextField();
		this.addChild(inputTextField);
		inputTextField.type = TextFieldType.INPUT;
		inputTextField.setTextFormat(textFormat);
		inputTextField.border = true;
		inputTextField.text = "sin(x)";
		inputTextField.width = 300;
		inputTextField.height = 60;

		acceptButton = new Button();
		this.addChild(acceptButton);
		acceptButton.addEventListener(Button.CLICK, onAcceptClick);
		acceptButton.setCaption("Enter");
		acceptButton.y = 65;
	}

	public function getFormulaText()
	{
		return inputTextField.text;
	}

	private function onAcceptClick(e :Event)
	{
		dispatchEvent(new Event(ENTRY_DONE));
	}
}

