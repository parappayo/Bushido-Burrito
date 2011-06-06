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

		//linearGradient(bitmapData);
		//circularGradient(bitmapData);
		radialDistanceGradient(bitmapData);
		//sphericalGradient(bitmapData);
	}

	public function dist(a :Point, b :Point) :Number
	{
		var dx :Number = b.x - a.x;
		var dy :Number = b.y - a.y;
		return Math.sqrt(dx*dx + dy*dy);
	}

	public function linearGradient(bitmapData :BitmapData) :void
	{
		var scale :Number = 256 / bitmapData.width;

		var p :Point = new Point();
		for (p.x = 0; p.x < bitmapData.width; p.x++)
		{
			var d :Number = p.x;
			d *= scale;
			d = Math.min(Math.max(0, d), 255);

			var r :uint = 255-d;
			var g :uint = 255-d;
			var b :uint = 255-d;
			var color :uint = (r * 256 * 256) + (g * 256) + b;

			for (p.y = 0; p.y < bitmapData.height; p.y++)
			{
				bitmapData.setPixel(p.x, p.y, color);
			}
		}
	}

	public function circularGradient(bitmapData :BitmapData) :void
	{
		var scale :Number = 256;

		var p :Point = new Point();
		for (p.x = 0; p.x < bitmapData.width; p.x++)
		{
			var d :Number = Math.cos(p.x * 2 / bitmapData.width);
			d *= scale;
			d = Math.min(Math.max(0, d), 255);

			var r :uint = d;
			var g :uint = d;
			var b :uint = d;
			var color :uint = (r * 256 * 256) + (g * 256) + b;

			for (p.y = 0; p.y < bitmapData.height; p.y++)
			{
				bitmapData.setPixel(p.x, p.y, color);
			}
		}
	}

	public function radialDistanceGradient(
			bitmapData :BitmapData,
			scale :Number = NaN,
			origin :Point = null
			) :void
	{
		if (isNaN(scale))
		{
			scale = 512 / bitmapData.width;
		}

		if (origin == null)
		{
			origin = new Point();
			origin.x = bitmapData.width / 2;
			origin.y = bitmapData.height / 2;
		}

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

	/**
	 *  note: this function is broken
	 */
	public function sphericalGradient(
			bitmapData :BitmapData,
			scale :Number = NaN,
			origin :Point = null
			) :void
	{
		if (isNaN(scale))
		{
			scale = 1;
		}
		scale *= 256;

		if (origin == null)
		{
			origin = new Point();
			origin.x = bitmapData.width / 2;
			origin.y = bitmapData.height / 2;
		}

		var p :Point = new Point();
		for (p.y = 0; p.y < bitmapData.height; p.y++)
		{
			var dy :Number = origin.y - p.y;
			var sin_y :Number = Math.sin(dy * 2 / bitmapData.height);

			for (p.x = 0; p.x < bitmapData.width; p.x++)
			{
				var dx :Number = origin.x - p.x;
				var cos_x :Number = Math.cos(dx * 2 / bitmapData.width);

				var d :Number = cos_x + sin_y;
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

