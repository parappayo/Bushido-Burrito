
using UnityEngine;

namespace BushidoBurrito
{

public class FrustrumCuller : MonoBehaviour
{
	public float ChildRadius = 1f;

	public static bool ContainedByPlanes(Vector3 position, float radius, Plane[] planes)
	{
		for (int i = 0; i != planes.Length; i++)
		{
			float distance = Vector3.Dot(position, planes[i].normal) + planes[i].distance;

			if (distance < -radius) {
				return false;
			}
		}

		return true;
	}

	private void Update()
	{
		var frustrum = GeometryUtility.CalculateFrustumPlanes(Camera.main);

		foreach (Transform child in this.transform) {
			child.gameObject.SetActive(ContainedByPlanes(child.position, this.ChildRadius, frustrum));
		}
	}
}

} // namespace
