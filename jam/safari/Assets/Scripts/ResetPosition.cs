
using UnityEngine;

public class ResetPosition : MonoBehaviour
{
	public bool UseStartingPosition = true;
	public Vector3 Position;
	public Quaternion Rotation;

	private void Awake()
	{
		if (UseStartingPosition)
		{
			Position = transform.position;
			Rotation = transform.rotation;
		}
	}

	public void Reset()
	{
		transform.position = Position;
		transform.rotation = Rotation;
	}

} // class
