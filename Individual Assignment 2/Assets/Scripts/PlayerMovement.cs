using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    public Rigidbody _rb;

    public float movementSpeed = 25f;
    public float rotationSpeed = 125f;

    private float verticalInput;
    private float horizontalInput;

    private void Start()
    {
        _rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        verticalInput = Input.GetAxis("Vertical") * movementSpeed;

        horizontalInput = Input.GetAxis("Horizontal") * rotationSpeed;
    }

    private void FixedUpdate()
    {
        Vector3 rotationVar = -Vector3.right * horizontalInput;

        Quaternion angleRotation = Quaternion.Euler(rotationVar * Time.fixedDeltaTime);

        _rb.MovePosition(transform.position + transform.forward * verticalInput * Time.fixedDeltaTime);
        _rb.MoveRotation(_rb.rotation * angleRotation);
    }
}
