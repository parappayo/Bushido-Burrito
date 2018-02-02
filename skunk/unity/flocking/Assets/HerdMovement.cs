
using UnityEngine;

namespace BushidoBurrito
{

public class HerdMovement : MonoBehaviour
{
	public Vector3 BaseMovement = new Vector3(1f, 0f, 0f);

	public float DriftMovement = 0.2f;
	public float FlockingWeight = 1f;

	public IDirectionProvider FlockingDirection;

	private void Start()
	{
		this.FlockingDirection = GetComponent<FlockingVector>() as IDirectionProvider;

		this.BaseMovement.x += Random.Range(-this.DriftMovement, this.DriftMovement);
		this.BaseMovement.z += Random.Range(-this.DriftMovement, this.DriftMovement);
	}

	private void LateUpdate()
	{
		var movement = this.BaseMovement + this.FlockingDirection.GetDirection() * this.FlockingWeight;
		transform.position = transform.position + movement * Time.deltaTime;
		transform.rotation = Quaternion.LookRotation(movement);
	}
}

} // namespace BushidoBurrito
