
using UnityEngine;

namespace BushidoBurrito
{

public class FlockingVector : MonoBehaviour
{
	public GameObject[] Neighbours;

	public float AlignmentFactor = 1f;
	public float CohesionFactor = 1f;
	public float SeparationFactor = 1f;

	public Vector3 Calculate()
	{
		Vector3 alignment = Vector3.zero;
		Vector3 cohesion = Vector3.zero;
		Vector3 separation = Vector3.zero;

		foreach (var neighbour in Neighbours) {
			alignment += neighbour.transform.forward;
			cohesion += neighbour.transform.position;
			separation += transform.position - neighbour.transform.position;
		}

		var result = (alignment * AlignmentFactor) +
			(cohesion * CohesionFactor) +
			(separation * SeparationFactor);

		return result.normalized;
	}
}

} // namespace BushidoBurrito
