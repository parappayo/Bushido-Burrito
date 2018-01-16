
using UnityEngine;

namespace BushidoBurrito
{

public class TransformSender : MonoBehaviour
{
	public string DataPrefix = string.Empty;

	[SerializeField]
	private TcpSender Network;

	[Tooltip("Whether to call Report() on every Update()")]
	public bool ReportOnUpdate = true;

	[Tooltip("Whether to use GameObject.transform or use main camera transform")]
	public bool UseMyTransform = false;

	private Vector3 OldPosition = Vector3.zero;
	private Quaternion OldRotation = Quaternion.identity;

	private void Start()
	{
		if (Network != null)
		{
			Network.OpenConnection();
		}
	}

	private void Update()
	{
		if (ReportOnUpdate)
		{
			Transform reportTransform = UseMyTransform ? gameObject.transform : Camera.main.gameObject.transform;

			if (!AreAlmostEqual(reportTransform.position, OldPosition) ||
				!AreAlmostEqual(reportTransform.rotation, OldRotation))
			{
				OldPosition = reportTransform.position;
				OldRotation = reportTransform.rotation;

				Report(reportTransform);
			}
		}
	}

	public void Report(Transform reportTransform)
	{
		if (Network == null)
		{
			Debug.Log("no network connection, cannot report position");
			return;
		}

		var dataStr = string.Format(
			"{0}Pos: {1}\tRot: {2}",
			DataPrefix,
			PositionToString(reportTransform.position),
			RotationToString(reportTransform.rotation) );
		Network.Write(dataStr);
	}

	private bool AreAlmostEqual(Vector3 from, Vector3 to, float diffFactor = 0.01f)
	{
		return ((from - to).sqrMagnitude <= (from * diffFactor).sqrMagnitude);
	}

	private bool AreAlmostEqual(Quaternion from, Quaternion to)
	{
		return 1f - Quaternion.kEpsilon < Quaternion.Dot(from, to);
	}

	private static string PositionToString(Vector3 position)
	{
		return string.Format(
			"({0}, {1}, {2})",
			position.x.ToString("F3"),
			position.y.ToString("F3"),
			position.z.ToString("F3"));
	}

	private static string RotationToString(Quaternion rotation)
	{
		return string.Format(
			"({0}, {1}, {2}, {3})",
			rotation.x.ToString("F3"),
			rotation.y.ToString("F3"),
			rotation.z.ToString("F3"),
			rotation.w.ToString("F3"));
	}
}

} // namespace BushidoBurrito
