
using UnityEngine;

public class AnimateMaterialOffset : MonoBehaviour
{
    /// <summary>
    /// Reference to the mesh renderer to animate. Set this in the editor.
    /// </summary>
    public MeshRenderer mesh;

    /// <summary>
    /// Tweak this in the editor to modify the rate at which the material animates.
    /// </summary>
    public float SpeedScale = 1.0f;

    private void FixedUpdate()
    {
        mesh.material.mainTextureOffset = mesh.material.mainTextureOffset + (new Vector2(Time.deltaTime, Time.deltaTime) * SpeedScale);
    }
}
