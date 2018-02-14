
using UnityEngine;

namespace BushidoBurrito
{

public class RadialSpawner : MonoBehaviour
{
	public uint SpawnCount;
	public GameObject Spawnable;
	public Vector3 Scale;

	private void Start()
	{
		for (uint i = 0; i < this.SpawnCount; i++) {
			Instantiate(this.Spawnable, Vector3.Scale(Random.insideUnitSphere, this.Scale), Quaternion.identity);
		}
	}
}

} // namespace
