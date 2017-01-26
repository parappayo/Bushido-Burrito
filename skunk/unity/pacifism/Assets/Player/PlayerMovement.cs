
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

            var inputVector = new Vector3(
                Input.GetAxis("Horizontal"),
                Input.GetAxis("Vertical"),
                0);

            if (inputVector.magnitude > 1f)
            {
                inputVector = inputVector.normalized;
            }

            return inputVector * scale;
        }
    }

} // class
