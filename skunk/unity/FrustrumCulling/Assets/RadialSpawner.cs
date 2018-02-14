
using UnityEngine;

namespace BushidoBurrito
{

public class RadialSpawner : MonoBehaviour
{
	public uint SpawnCount;
	public GameObject Spawnable;
	public Transform Parent;
	public Vector3 Scale = Vector3.one;

	private void Start()
	{
		for (uint i = 0; i < this.SpawnCount; i++) {
			var spawn = Instantiate(this.Spawnable, Vector3.Scale(Random.insideUnitSphere, this.Scale), Quaternion.identity) as GameObject;
			spawn.transform.parent = this.Parent;
		}
	}
}

} // namespace
