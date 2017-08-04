
using UnityEngine;

public class QuadBatchGL : MonoBehaviour
{
	public Texture Texture;

	public float QuadSize = 1f;

	public Vector2 Pivot = new Vector2(0.5f, 0.5f);

	public Vector2[] Positions;

	private Material Material;

	private void DrawCounterClockwiseQuad(Vector2 pos, Vector2 pivot)
	{
		var pos_x = pos.x - pivot.x;
		var pos_y = pos.y - pivot.y;
		var pos_x2 = pos_x + this.QuadSize;
		var pos_y2 = pos_y + this.QuadSize;

		GL.TexCoord2(0f, 0f);
		GL.Vertex3(pos_x, pos_y, 0f);

		GL.TexCoord2(0f, 1f);
		GL.Vertex3(pos_x, pos_y2, 0f);

		GL.TexCoord2(1f, 1f);
		GL.Vertex3(pos_x2, pos_y2, 0f);
		
		GL.TexCoord2(1f, 0f);
		GL.Vertex3(pos_x2, pos_y, 0f);
	}

	private void CreateMaterial()
	{
		Shader shader = Shader.Find("Unlit/Transparent");
		this.Material = new Material(shader);
		this.Material.hideFlags = HideFlags.HideAndDontSave;
	}

	private void OnRenderObject()
	{
		if (this.Material == null) {
			CreateMaterial();
		}

		this.Material.mainTexture = this.Texture;

		this.Material.SetPass(0);
		
		GL.PushMatrix();
		GL.MultMatrix(transform.localToWorldMatrix);
		GL.Begin(GL.QUADS);

		var pivot = this.Pivot * this.QuadSize;

		foreach (var pos in this.Positions) {
			DrawCounterClockwiseQuad(pos, pivot);
		}

		GL.End();
		GL.PopMatrix();
	}
}	
