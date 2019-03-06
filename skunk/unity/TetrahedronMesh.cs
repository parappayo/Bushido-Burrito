
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshFilter))]
public class TetrahedronMesh : MonoBehaviour
{
	private MeshFilter _meshFilter;

	private void Awake()
	{
		_meshFilter = GetComponent<MeshFilter>();
		_meshFilter.mesh = Create(transform.localScale);
	}

	public static Mesh Create(Vector3 scale)
	{
		var mesh = new Mesh();

		float rootThreeFourths = Mathf.Sqrt(3f / 4f);

		scale = new Vector3(scale.x, scale.y * rootThreeFourths, scale.z * rootThreeFourths);
		Vector3 half = scale * 0.5f;

		mesh.vertices = new Vector3[12]
		{
			new Vector3(-half.x, -half.y, half.z),
			new Vector3(half.x,  -half.y, half.z),
			new Vector3(0f,      half.y,  0f),

			new Vector3(0f,      -half.y, -half.z),
			new Vector3(-half.x, -half.y, half.z),
			new Vector3(0f,      half.y,  0f),

			new Vector3(half.x,  -half.y, half.z),
			new Vector3(0f,      -half.y, -half.z),
			new Vector3(0f,      half.y,  0f),

			new Vector3(-half.x, -half.y, half.z),
			new Vector3(half.x,  -half.y, half.z),
			new Vector3(0f,      -half.y, -half.z),
		};

		mesh.triangles = new int[12]
		{
			0, 1, 2,
			3, 4, 5,
			6, 7, 8,
			9, 11, 10,
		};

		mesh.RecalculateNormals();

		return mesh;
	}
}
