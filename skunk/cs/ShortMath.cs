using System;
using System.Diagnostics;

namespace ShortMath
{
	public delegate double MonadicDoubleFunc(double arg);
	public delegate double DyadicDoubleFunc(double arg1, double arg2);

	// angle represented by radians as a fixed point 16 bit number
	struct Angle
	{
		const float FloatTau = 2.0f * (float) Math.PI;

		private short rawValue;

		public Angle(Angle angle)
		{
			this.rawValue = angle.rawValue;
		}

		public Angle(float angle)
		{
			this.rawValue = (short) (angle * 10000.0f);
		}

		public Angle(double angle)
		{
			this.rawValue = (short) (angle * 10000.0);
		}

		public static explicit operator Angle(float angle)
		{
			return new Angle(angle);
		}

		public static explicit operator float(Angle angle)
		{
			return ((float) angle.rawValue) / 10000.0f;
		}

		public static explicit operator Angle(double angle)
		{
			return new Angle(angle);
		}

		public static explicit operator double(Angle angle)
		{
			return ((double) angle.rawValue) / 10000.0;
		}

		public static implicit operator string(Angle angle)
		{
			float angleFloat = (float) angle;
			return angleFloat.ToString();
		}

		public static Angle[] GenerateTable(MonadicDoubleFunc f)
		{
			Angle angle = new Angle();
			Angle[] table = new Angle[ushort.MaxValue+1];

			for (int i = 0; i <= ushort.MaxValue; i++) {
				angle.rawValue = (short) (i - ushort.MaxValue / 2);
				table[i] = (Angle) f((double) angle);
			}
			return table;
		}

		public static Angle[] GenerateTable(DyadicDoubleFunc f, double param)
		{
			Angle angle = new Angle();
			Angle[] table = new Angle[ushort.MaxValue+1];

			for (int i = 0; i <= ushort.MaxValue; i++) {
				angle.rawValue = (short) (i - ushort.MaxValue / 2);
				table[i] = (Angle) f((double) angle, param);
			}
			return table;
		}
	}

	class Test
	{
		public static void Main()
		{
			Stopwatch stopwatch = new Stopwatch();

			stopwatch.Start();
			Angle[] sineTable = Angle.GenerateTable(Math.Sin);
			stopwatch.Stop();

			Console.WriteLine("Generated Sine Table: {0}", stopwatch.Elapsed);
			Console.WriteLine("Sample values:");
			for (ushort i = 0; i < 5000; i += 1000) {
				Console.WriteLine(sineTable[i]);
			}

			stopwatch.Start();
			Angle[] cosineTable = Angle.GenerateTable(Math.Cos);
			stopwatch.Stop();

			Console.WriteLine("Generated Cosine Table: {0}", stopwatch.Elapsed);
			Console.WriteLine("Sample values:");
			for (ushort i = 0; i < 5000; i += 1000) {
				Console.WriteLine(cosineTable[i]);
			}
		}
	}
}
