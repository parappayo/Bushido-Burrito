/*
 *  GradientTest.as
 *
 *  Flex SDK demo with runtime generated gradient bitmap data.
 */

package {

import mx.core.UIComponent;
import flash.display.*;
import flash.geom.*;

public class GradientTest extends UIComponent
{
	public function GradientTest()
	{
		var bitmapData :BitmapData = new BitmapData(128, 128);
		var bitmap :Bitmap = new Bitmap(bitmapData);
		addChild(bitmap);

		radialDistanceGradient(bitmapData);
	}

	public function dist(a :Point, b :Point) :Number
	{
		var dx :Number = b.x - a.x;
		var dy :Number = b.y - a.y;
		return Math.sqrt(dx*dx + dy*dy);
	}

	public function radialDistanceGradient(bitmapData :BitmapData) :void
	{
		var scale :Number = 512 / bitmapData.width;

		var origin :Point = new Point();
		origin.x = bitmapData.width / 2;
		origin.y = bitmapData.height / 2;

		radialDistanceGradient2(bitmapData, scale, origin);
	}

	public function radialDistanceGradient2(
			bitmapData :BitmapData,
			scale :Number,
			origin :Point
			) :void
	{
		var p :Point = new Point();
		for (p.y = 0; p.y < bitmapData.height; p.y++)
		{
			for (p.x = 0; p.x < bitmapData.width; p.x++)
			{
				var d :Number = dist(origin, p);
				d *= scale;
				d = Math.min(Math.max(0, d), 255);

				var r :uint = 255-d;
				var g :uint = 255-d;
				var b :uint = 255-d;
				var color :uint = (r * 256 * 256) + (g * 256) + b;

				bitmapData.setPixel(p.x, p.y, color);
			}
		}
	}

} // class GradientTest

} // package

