
using UnityEngine;

namespace BushidoBurrito
{

public class FlockingVector : MonoBehaviour
{
	public GameObject[] Neighbours;

	public float NeighbourDistance = 5f;

	public float AlignmentWeight = 1f;
	public float CohesionWeight = 1f;
	public float SeparationWeight = 1f;

	private void Start()
	{
		Neighbours = new GameObject[10];
		FindNeighbours();
	}

	public Vector3 Calculate()
	{
		Vector3 alignment = Vector3.zero;
		Vector3 cohesion = Vector3.zero;
		Vector3 separation = Vector3.zero;

		foreach (var neighbour in Neighbours) {
			if (!neighbour) { continue; }

			var deltaPos = neighbour.transform.position - transform.position;
			alignment += neighbour.transform.forward;
			cohesion += deltaPos;
			separation += -deltaPos;
		}

		var result = (alignment * AlignmentWeight / Neighbours.Length) +
			(cohesion * CohesionWeight / Neighbours.Length) +
			(separation.normalized * SeparationWeight);

		return result;
	}

	public void FindNeighbours()
	{
		uint count = 0;

		// this implementation is unnecessarily slow
		foreach (Transform sibling in transform.parent) {
			var distanceSquared = (sibling.transform.position - transform.position).sqrMagnitude;

			if (distanceSquared < NeighbourDistance * NeighbourDistance) {
				Neighbours[count] = sibling.gameObject;
				count++;

				if (count >= Neighbours.Length) {
					return;
				}
			}
		}
	}
}

} // namespace BushidoBurrito
