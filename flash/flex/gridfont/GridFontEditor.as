/*
 *  GridFontEditor.as
 *
 *  Flex SDK application to display and allow the user to edit grid fonts.
 */

package {

import mx.core.UIComponent;

public class GridFontEditor extends UIComponent
{
	private var _testGlyph :GridFontGlyph;

	public function GridFontEditor()
	{
		_testGlyph = new GridFontGlyph();
		addChild(_testGlyph);

		_testGlyph.x = 50;
		_testGlyph.y = 20;
	}
}

} // package

