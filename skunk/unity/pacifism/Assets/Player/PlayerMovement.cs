
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    public float Speed = 1f;

    void Update()
    {
        transform.position = transform.position + (transform.rotation * Movement);
    }

    private Vector3 Movement
    {
        get
        {
            var scale = Speed * Time.deltaTime;
            return new Vector3(
                Input.GetAxis("Horizontal") * scale,
                Input.GetAxis("Vertical") * scale,
                0);
        }
    }

} // class
