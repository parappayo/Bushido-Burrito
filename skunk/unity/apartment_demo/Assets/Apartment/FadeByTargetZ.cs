
using UnityEngine;

public class FadeByTargetZ : MonoBehaviour
{
    public GameObject Target;
    public float MinZ = 0f;
    public float MaxZ = 0f;
    public Color ActiveColor;
    public Color InactiveColor;

    private Renderer _renderer;
    private Color _fromColor;
    private bool _triggered;
    private float _fadeElapsedTime;

    void Start()
    {
        _renderer = GetComponent<Renderer>();

        _renderer.material.color = InactiveColor;
    }

    void Update()
    {
        _fadeElapsedTime += Time.deltaTime;

        if (Triggered != _triggered)
        {
            _triggered = Triggered;
            _fadeElapsedTime = 0f;
            _fromColor = _renderer.material.color;
        }

        Color toColor = Triggered ? ActiveColor : InactiveColor;

        _renderer.material.color = Color.Lerp(_fromColor, toColor, _fadeElapsedTime);
    }

    bool Triggered
    {
        get
        {
            return Target.transform.position.z > transform.position.z + MinZ &&
                   Target.transform.position.z < transform.position.z + MaxZ;
        }
    }

} // class
