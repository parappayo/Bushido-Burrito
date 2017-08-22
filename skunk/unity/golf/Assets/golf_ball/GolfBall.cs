
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class GolfBall : MonoBehaviour
{
	public void Shoot(Vector3 force) {
		this.GetComponent<Rigidbody>().AddForce(force);
	}

	public void TestShot() {
		var force = (this.transform.forward + this.transform.up) * 100f;
		Shoot(force);
	}
}
