using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[RequireComponent(typeof(LineRenderer))]
public class bezier : MonoBehaviour
{

    public Transform[] controlPoint;
    public LineRenderer lineRenderer;

    private int layerOrder = 0;

    private int _segmentNumber = 500;
    void Start()
    {
        if (!lineRenderer)
        {
            lineRenderer = GetComponent<LineRenderer>();
        }
        lineRenderer.sortingLayerID = layerOrder;
    }
    void Update()
    {
        draw();
    }

    void draw()
    {
        for (int i = 1; i < _segmentNumber; i++)
        {
            float t = i / (float)_segmentNumber;
            int nodeIndex = 0;
            Vector3 pixel = getPoint(t, controlPoint[nodeIndex].position, controlPoint[nodeIndex + 1].position,
                controlPoint[nodeIndex + 2].position, controlPoint[nodeIndex + 3].position);
            lineRenderer.positionCount = i;
            lineRenderer.SetPosition(i - 1, pixel);
        }
    }

    Vector3 getPoint(float t, Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3)
    {
        float s = 1 - t;
        Vector3 p = p0 * s * s * s + 3 * p1 * t * s * s + 3 * p2 * t * t * s + p3 * t * t * t;
        return p;

    }
}