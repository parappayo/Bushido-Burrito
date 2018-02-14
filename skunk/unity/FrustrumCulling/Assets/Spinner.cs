
using UnityEngine;

namespace BushidoBurrito
{

public class Spinner : MonoBehaviour
{
	public Vector3 EulerVelocity;

	private void Update()
	{
		transform.rotation *= Quaternion.Euler(EulerVelocity * Time.deltaTime);
	}
}

} // namespace
