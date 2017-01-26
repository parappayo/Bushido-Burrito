
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    public float MovementSpeed = 1.0f;

    void FixedUpdate()
    {
        transform.position = transform.position + (transform.rotation * Movement);
    }

    private Vector3 Movement
    {
        get
        {
            var scale = MovementSpeed * Time.deltaTime;
            return new Vector3(
                Input.GetAxis("Horizontal") * scale,
                0,
                Input.GetAxis("Vertical") * scale);
        }
    }

} // class
