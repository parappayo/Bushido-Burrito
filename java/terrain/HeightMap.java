
import java.awt.Point;

public class HeightMap {

	private float[] mData;

	private int mHeight, mWidth;
	public int GetHeight() { return mHeight; }
	public int GetWidth()  { return mWidth; }

	// height map will be from 0 to this value
	public static final float MaxValue = 1.0f;

	public HeightMap(int height, int width) {

		mHeight = height;
		mWidth = width;

		mData = new float[height * width];
	}

	public float GetData(Point p) {

		return mData[p.y * mWidth + p.x];
	}

	public void SetData(Point p, float value) {

		mData[p.y * mWidth + p.x] = value;
	}

	/**
	 *  It is assumed that data exists for topLeft, bottomRight, topRight, and bottomLeft points.
	 */
	private void GenerateRecursive( Point topLeft,
					Point bottomRight,
					float scale ) {

		if (bottomRight.x - topLeft.x < 2) { return; }

		Point topRight    = new Point( bottomRight.x, topLeft.y );
		Point bottomLeft  = new Point( topLeft.x, bottomRight.y );
		Point top         = new Point( (bottomRight.x + topLeft.x)/2, topLeft.y );
		Point left        = new Point( topLeft.x, (bottomRight.y + topLeft.y)/2 );
		Point bottom      = new Point( top.x, bottomRight.y );
		Point right       = new Point( bottomRight.x, left.y );
		Point center      = new Point( top.x, left.y );

		float topLeftData = GetData(topLeft);
		float topRightData = GetData(topRight);
		float bottomLeftData = GetData(bottomLeft);
		float bottomRightData = GetData(bottomRight);

		// the diamond step - generate a center point with some randomness
		float centerData = (topLeftData + topRightData + bottomLeftData + bottomRightData) / 4.0f;
		double rand = Math.random() - 0.5f;
		centerData += rand * scale * MaxValue;
		centerData += rand * (1.0f - scale) * MaxValue * 0.1f; // extra noise
		if (centerData > MaxValue) { centerData = MaxValue; }
		SetData( center, centerData );

		// the square step - generate data for the four edge points

		float leftData = (topLeftData + bottomLeftData + centerData) / 3.0f;
		SetData( left, leftData );

		float rightData = (topRightData + bottomRightData + centerData) / 3.0f;
		SetData( right, rightData );

		float topData = (topLeftData + topRightData + centerData) / 3.0f;
		SetData( top, topData );

		float bottomData = (bottomLeftData + bottomRightData + centerData) / 3.0f;
		SetData( bottom, bottomData );

		GenerateRecursive( topLeft, center, scale * 0.5f );
		GenerateRecursive( center, bottomRight, scale * 0.5f );
		GenerateRecursive( top, right, scale * 0.5f );
		GenerateRecursive( left, bottom, scale * 0.5f );
	}

	public void Generate() {

		if (mHeight == 0 || mWidth == 0) return;

		Point topLeft     = new Point( 0,         0         );
		Point topRight    = new Point( mWidth-1,  0         );
		Point bottomLeft  = new Point( 0,         mHeight-1 );
		Point bottomRight = new Point( mWidth-1,  mHeight-1 );
		Point top         = new Point( mWidth/2,  0         );
		Point left        = new Point( 0,         mHeight/2 );
		Point bottom      = new Point( mWidth/2,  mHeight-1 );
		Point right       = new Point( mWidth-1,  mHeight/2 );
		Point center      = new Point( mWidth/2,  mHeight/2 );

		SetData( topLeft, 0.0f );
		SetData( topRight, 0.0f );
		SetData( bottomLeft, 0.0f );
		SetData( bottomRight, 0.0f );
		SetData( top, 0.0f );
		SetData( left, 0.0f );
		SetData( bottom, 0.0f );
		SetData( right, 0.0f );
		SetData( center, MaxValue );

		GenerateRecursive( topLeft, center, 0.5f );
		GenerateRecursive( center, bottomRight, 0.5f );
		GenerateRecursive( top, right, 0.5f );
		GenerateRecursive( left, bottom, 0.5f );
	}

	/**
	 *  For testing purposes, generates data and dumps it to console.
	 */
	static public void main(String[] args) {

		HeightMap map = new HeightMap(9, 9);
		map.Generate();

		Point p = new Point();
		for (int y = 0; y < map.GetHeight(); y++) {
			for (int x = 0; x < map.GetWidth(); x++) {

				p.x = x;
				p.y = y;

				System.out.format("%.2f", map.GetData(p));
				System.out.print("\t");
			}
			System.out.println();
		}	
	}
}

