
using UnityEngine;

namespace BushidoBurrito
{

public class Spinner : MonoBehaviour
{
	public Vector3 EulerVelocity;

	private void Update()
	{
		this.transform.rotation *= Quaternion.Euler(this.EulerVelocity * Time.deltaTime);
	}
}

} // namespace
