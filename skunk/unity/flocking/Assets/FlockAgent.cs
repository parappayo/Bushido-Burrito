
using UnityEngine;

namespace BushidoBurrito
{

public class FlockAgent : MonoBehaviour
{
	public Vector3 BaseMovement = new Vector3(1f, 0f, 0f);

	public float DriftMovement = 0.2f;
	public float FlockingWeight = 1f;

	public IDirectionProvider FlockDirection;

	private void Start()
	{
		this.FlockDirection = GetComponent<FlockDirection>() as IDirectionProvider;

		this.BaseMovement.x += Random.Range(-this.DriftMovement, this.DriftMovement);
		this.BaseMovement.z += Random.Range(-this.DriftMovement, this.DriftMovement);
	}

	private void LateUpdate()
	{
		var movement = this.BaseMovement + this.FlockDirection.GetDirection() * this.FlockingWeight;
		transform.position = transform.position + movement * Time.deltaTime;
		transform.rotation = Quaternion.LookRotation(movement);
	}
}

} // namespace BushidoBurrito
