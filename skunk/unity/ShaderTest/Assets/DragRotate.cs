
using UnityEngine;

public class DragRotate : MonoBehaviour
{
    public float Sensitivity = 0.2f;

    private Vector3 _OldMousePosition = Vector3.zero;

    private void OnMouseDown()
    {
        _OldMousePosition = Input.mousePosition;
    }

    private void OnMouseDrag()
    {
        Vector3 rotateBy = (Input.mousePosition - _OldMousePosition) * Sensitivity;

        transform.Rotate(new Vector3(rotateBy.y, -rotateBy.x, 0));

        _OldMousePosition = Input.mousePosition;
    }
}
