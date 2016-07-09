
using UnityEngine;

public class Follow : MonoBehaviour
{
    public float Speed = 1f;

    public GameObject Target;

    void Update()
    {
        transform.position = transform.position + (transform.rotation * Movement);
    }

    private Vector3 Movement
    {
        get
        {
            if (!Target) { return Vector3.zero;  }
            var scale = Speed * Time.deltaTime;
            var direction = Target.transform.position - transform.position;
            return direction.normalized * scale;
        }
    }

} // class
