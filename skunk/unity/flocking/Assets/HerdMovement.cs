
using UnityEngine;

namespace BushidoBurrito
{

public class HerdMovement : MonoBehaviour
{
	public Vector3 BaseMovement = new Vector3(1f, 0f, 0f);

	public float DriftMovement = 0.2f;

	private FlockingVector FlockingVector;

	private void Start()
	{
		this.FlockingVector = GetComponent<FlockingVector>();

		BaseMovement.x += Random.Range(-DriftMovement, DriftMovement);
		BaseMovement.z += Random.Range(-DriftMovement, DriftMovement);
	}

	private void LateUpdate()
	{
		var movement = BaseMovement + this.FlockingVector.Calculate();
		transform.position = transform.position + movement * Time.deltaTime;
	}
}

} // namespace BushidoBurrito
