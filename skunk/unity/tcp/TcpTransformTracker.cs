
using System;
using System.Text.RegularExpressions;

using UnityEngine;

namespace BushidoBurrito
{

public class TcpTransformTracker : MonoBehaviour, TcpReceiverObserver
{
	public GameObject Target;

	private static TcpTransformTracker LockObject;
	private static Vector3 ClientPosition;
	private static Quaternion ClientRotation;

	private void Start()
	{
		if (Target == null)
		{
			Target = gameObject;
		}

		if (LockObject == null)
		{
			LockObject = this;
		}

		TcpReceiver.Observers.Add(this);
	}

	private void OnDestroy()
	{
		TcpReceiver.Observers.Remove(this);
	}

	private void Update()
	{
		if (Target == null) { return; }

		lock (LockObject)
		{
			Target.transform.position = ClientPosition;
			Target.transform.rotation = ClientRotation;
		}
	}

	public void HandleData(string data)
	{
		if (LockObject == null) { return; }

		Vector3 position;
		Quaternion rotation;
		if (!ParseTransform(data, out position, out rotation))
		{
			Debug.Log(string.Format("TcpTransformTracker parse error in {0}", data));
			return;
		}

		lock (LockObject)
		{
			ClientPosition = position;
			ClientRotation = rotation;
		}
	}

	private static bool ParseTransform(string data, out Vector3 position, out Quaternion rotation)
	{
		position = Vector3.zero;
		rotation = Quaternion.identity;

		const string regexPattern = @"Pos\w*:\s*\((.?\d+\.\d+), (.?\d+\.\d+), (.?\d+\.\d+)\)\s+Rot\w*:\s*\((.?\d+\.\d+), (.?\d+\.\d+), (.?\d+\.\d+), (.?\d+\.\d+)\)";

		var matches = Regex.Matches(data, regexPattern);

		if (matches.Count != 1) { return false; }

		try
		{
			var match = matches[0];

			if (match.Groups.Count < 8) { return false; }

			position = new Vector3(
				float.Parse(match.Groups[1].ToString()),
				float.Parse(match.Groups[2].ToString()),
				float.Parse(match.Groups[3].ToString()));

			rotation = new Quaternion(
				float.Parse(match.Groups[4].ToString()),
				float.Parse(match.Groups[5].ToString()),
				float.Parse(match.Groups[6].ToString()),
				float.Parse(match.Groups[7].ToString()));
		}
		catch (FormatException e)
		{
			Debug.Log(string.Format("TcpTransformTracker format exception: {0}", e));
			return false;
		}

		return true;
	}
}

} // namespace BushidoBurrito
