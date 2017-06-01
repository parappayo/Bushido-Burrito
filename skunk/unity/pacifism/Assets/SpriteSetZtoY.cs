
using UnityEngine;

public class SpriteSetZtoY : MonoBehaviour
{
	public float Scale = 0.0001f;

	private void Update ()
	{
		transform.position = new Vector3(
			transform.position.x,
			transform.position.y,
			transform.position.y * Scale);
	}
}
