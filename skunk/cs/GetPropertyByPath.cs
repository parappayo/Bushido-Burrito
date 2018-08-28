using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace BushidoBurrito
{
	// experiment using .NET reflection
	public static class ObjectExtension
	{
		public static bool TryGetPropertyByPath<T>(
			out object result,
			T source,
			IReadOnlyList<string> path,
			BindingFlags bindingFlags = BindingFlags.Public | BindingFlags.Instance)
		{
			result = null;

			if (source == null)
			{
				return false;
			}

			var property = source.GetType().GetProperty(path.First(), bindingFlags);

			if (property == null)
			{
				return false;
			}

			result = property.GetValue(source);

			return path.Count < 2 || TryGetPropertyByPath(out result, result, path.Skip(1).ToArray(), bindingFlags);
		}

		public static object GetPropertyByPath(
			this Object source,
			string path,
			BindingFlags bindingFlags = BindingFlags.Public | BindingFlags.Instance)
		{
			TryGetPropertyByPath(out var result, source, path.Split('/'), bindingFlags);
			return result;
		}
	}

	class TestObject
	{
		public string Data1 { get; set; }

		public object Data2 { get; set; }
	}

	class Program
	{
		static void Main(string[] args)
		{
			var testObject1 = new TestObject {Data1 = "foo", Data2 = null};
			var testObject2 = new TestObject {Data1 = "bar", Data2 = testObject1};

			if (ObjectExtension.TryGetPropertyByPath(out var property1, testObject2, "Data1".Split('/')))
			{
				Console.WriteLine((string)property1);
			}

			Console.WriteLine((string)testObject2.GetPropertyByPath("Data1"));

			if (ObjectExtension.TryGetPropertyByPath(out var property2, testObject2, "Data2/Data1".Split('/')))
			{
				Console.WriteLine((string)property2);
			}

			// this part fails, gets null
			Console.WriteLine((string)testObject1.GetPropertyByPath("Data2/Data1"));
		}
	}
}
